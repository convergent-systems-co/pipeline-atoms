import type { APIRoute } from 'astro';
import catalog from '../../../public/exports/catalog.json';

export const GET: APIRoute = () => {
  const atomTypes: Record<string, number> = {};
  for (const atom of (catalog.atoms as any[])) {
    const t = atom.type || 'unknown';
    atomTypes[t] = (atomTypes[t] || 0) + 1;
  }

  const payload = {
    version: '1',
    spec_version: 'atoms-spec/v1.1.0',
    name: 'pipeline-atoms',
    description: 'Pipeline primitives for CI/CD — reusable workflow steps, trigger conditions, gates, deployment recipes. Composable, versioned, runtime-agnostic.',
    site: 'https://pipeline-atoms.com',
    federation: 'convergent-systems.co',
    catalog: {
      total_atoms: (catalog.atoms as any[]).length,
      total_compositions: (catalog.compositions as any[]).length,
      atom_types: atomTypes,
      exports_url: 'https://pipeline-atoms.com/exports/catalog.json',
    },
    endpoints: {
      atoms: 'https://pipeline-atoms.com/atoms/',
      exports: 'https://pipeline-atoms.com/exports/catalog.json',
      ai_discovery: 'https://pipeline-atoms.com/ai/index.json',
    },
    workflow: [
      '1. Fetch /ai/index.json to discover catalog structure and atom types.',
      '2. Browse /atoms/ to explore atoms grouped by type.',
      '3. Fetch /exports/catalog.json for the full machine-readable catalog.',
    ],
  };

  return new Response(JSON.stringify(payload, null, 2), {
    headers: { 'Content-Type': 'application/json' },
  });
};
