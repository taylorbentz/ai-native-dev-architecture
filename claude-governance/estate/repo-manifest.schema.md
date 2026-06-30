# Per-Repo Manifest — the interface every repo implements

Each repo in the estate declares a small set of facts about itself in a `repo-manifest.json` at its
root. This is the **interface** that lets generic, shared capability work against any repo without
hard-coding knowledge of it — the shared hooks and skills read these declared facts rather than
carrying a built-in list.

The [estate map](estate-map.json) is the **aggregation** of every repo's manifest, assembled in one
place so a coordinating session can reason over all repos at once. The split is deliberate:

- **Each repo owns its own facts** (declared locally, reviewed by that repo's owners).
- **The estate map owns the assembled view** (so cross-repo work and discovery have one source).

## Fields

| Field | Meaning |
|---|---|
| `name` | The repo's identifier. |
| `capability` | One line: what job this repo does. Used for discovery ("which repo handles X?"). |
| `stack` | Primary language/toolchain — selects which conventions and verification apply. |
| `branch_model` | `trunk` or `dev-then-trunk` — determines the safety meaning of a push (see the estate map's `branch_model_semantics`). |
| `main_push_deploys_to` | The environment a main-branch push actually reaches. The shared push-safety hook reads this. |
| `verify` | The command that builds and tests this repo. The shared `ship` skill reads this. |
| `depends_on` / `provides_to` | Cross-repo edges — lets a session sequence a cascading change correctly. |

## Example

```json
{
  "name": "productA_python",
  "capability": "data pipeline / Python role logic",
  "stack": "python",
  "branch_model": "trunk",
  "main_push_deploys_to": "app_staging",
  "verify": "pytest",
  "depends_on": [],
  "provides_to": ["productA_terraform"]
}
```

## Why this replaces the old "compose capabilities up into the hub" step

Previously, shared behavior was hand-distributed (symlinks, copies) and the assistant carried built-in
knowledge of each repo. Now: shared behavior is a **plugin**, and repo-specific knowledge is **declared
by the repo** through this manifest. Generic capability + declared facts = no central list to maintain,
and no drift.

## Keeping the map and the manifests in agreement

Splitting the facts (per-repo manifests) from the assembled view (the estate map) introduces one risk:
a repo updates its manifest and the map is not updated to match, or vice versa. The check
[`validate-estate-map.sh`](validate-estate-map.sh) catches exactly that — it compares every map row
against the matching `repo-manifest.json` and flags any disagreement, any map row with no manifest, and
any manifest with no map row. Run it before committing a manifest change, and in the governance repo's
CI. In this illustration the repos sit side by side; in real life, point `WORKSPACE_ROOT` at wherever
they're checked out.
