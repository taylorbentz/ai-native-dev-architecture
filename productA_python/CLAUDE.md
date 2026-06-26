# productA_python

A Python data pipeline. Owns its own assistant capabilities in `.claude/`; the hub links them up.

- **Build/verify:** `pytest`
- **Branch model:** trunk
- **Module layout:** `src/etl/` holds extract/transform/load steps; one module per stage.
- **Style:** 4-space indent, type hints on public functions, no tabs.
