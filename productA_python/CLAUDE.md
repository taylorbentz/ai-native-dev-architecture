# productA_python

A Python data pipeline. Owns its own assistant capabilities in `.claude/` and declares its facts in
[`repo-manifest.json`](repo-manifest.json). Shared, team-wide capability comes from the governance
plugin; this repo only holds what is specific to it.

- **Build/verify:** `pytest`
- **Branch model:** trunk
- **Module layout:** `src/etl/` holds extract/transform/load steps; one module per stage.
- **Style:** 4-space indent, type hints on public functions, no tabs.
