# pipeline-atoms

Catalog of CI/CD pipeline primitives — reusable workflow steps, trigger conditions, gates, deployment recipes. Composable, versioned, runtime-agnostic via a canonical pipeline schema published in [schema-atoms](https://github.com/convergent-systems-co/schema-atoms). Part of the [convergent-systems-co](https://github.com/convergent-systems-co) atoms ecosystem.

| | |
|---|---|
| **Type** | `pipeline` |
| **Site** | [`pipeline-atoms.com`](https://pipeline-atoms.com) (apex, Cloudflare-proxied) |
| **Catalog content** | `pipelines/` (empty — additions begin once the pipeline schema lands in schema-atoms) |
| **Ecosystem** | Federated under `xdao.co` |

## Status

Bootstrap state. The repo exists with the standard atoms scaffold; the catalog is empty. Pipelines will be authored once the canonical `pipeline` schema is published in [schema-atoms](https://github.com/convergent-systems-co/schema-atoms).

## Layout

```
pipelines/                       catalog content (empty — pipeline definitions land here)
schemas/                         local schema references; canonical schemas live in schema-atoms
web/site/                        Astro static site → pipeline-atoms.com
infra/terraform/                 Cloudflare Pages + DNS via split-token aliased providers
ATOMS.yml                        catalog manifest (conforms to atoms-spec/v1)
```

## License

Apache-2.0. See [LICENSE](LICENSE).
