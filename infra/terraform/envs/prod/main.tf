terraform {
  required_version = ">= 1.7.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

# Multi-provider setup: this module touches account-level Pages resources
# and zone-level DNS records. After the 2026-05-23 core-infra token split,
# each plane has its own narrow API token (see ~/.ai/Common.md §4 and
# convergent-systems-co/core-infra/terraform/cloudflare/{account,dns}-token).

provider "cloudflare" {
  alias     = "account"
  api_token = var.account_token
}

provider "cloudflare" {
  alias     = "dns"
  api_token = var.dns_token
}

# --- Pages project + custom domain (account-scoped) -------------------------

resource "cloudflare_pages_project" "this" {
  provider          = cloudflare.account
  account_id        = var.cloudflare_account_id
  name              = "pipeline-atoms"
  production_branch = "main"
}

resource "cloudflare_pages_domain" "custom" {
  provider     = cloudflare.account
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.this.name
  name         = "pipeline-atoms.com"
}

# --- DNS record at the zone apex (zone-scoped) ------------------------------
# NOTE: this resource is BLOCKED until pipeline-atoms.com is added to the
# allowlist in convergent-systems-co/core-infra/terraform/cloudflare/dns-token
# and that module is re-applied (requires Global API Key — the rotate-token
# can't add new zones to a token's resource list).

resource "cloudflare_dns_record" "pages_cname" {
  provider = cloudflare.dns
  zone_id  = var.zone_id
  name     = "pipeline-atoms.com"
  type     = "CNAME"
  content  = "${cloudflare_pages_project.this.name}.pages.dev"
  proxied  = true
  ttl      = 1

  comment = "Cloudflare Pages apex — managed by terraform"

  depends_on = [cloudflare_pages_domain.custom]
}

# --- Inputs -----------------------------------------------------------------

variable "cloudflare_account_id" {
  description = "Cloudflare account ID that owns the Pages project."
  type        = string
}

variable "zone_id" {
  description = "Cloudflare zone ID for pipeline-atoms.com."
  type        = string
}

variable "account_token" {
  description = "Cloudflare API token with Account Pages Edit scope. From 'Convergent Systems - Account' in 1Password Developer vault."
  type        = string
  sensitive   = true
}

variable "dns_token" {
  description = "Cloudflare API token with Zone DNS Edit scope. From 'Convergent Systems - DNS' in 1Password Developer vault. NOTE: dns-token allowlist must include pipeline-atoms.com — extend in core-infra and re-apply."
  type        = string
  sensitive   = true
}

# --- Outputs ----------------------------------------------------------------

output "project_name" {
  value = cloudflare_pages_project.this.name
}

output "subdomain" {
  value       = cloudflare_pages_project.this.subdomain
  description = "Default *.pages.dev hostname for the project."
}

output "custom_domain" {
  value       = cloudflare_pages_domain.custom.name
  description = "Apex custom domain attached to the Pages project."
}
