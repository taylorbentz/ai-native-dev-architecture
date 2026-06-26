---
name: etl-validate
description: Validate an ETL module — schema contract, idempotency, and safe handling of empty inputs.
effort: high
allowed-tools: >
  Read
  Bash(pytest *)
---

# /etl-validate — Validate an ETL Module

Composed into the hub as `pa-etl-validate`.

## Procedure

1. Read the target module under `src/etl/`.
2. Check: declared input/output schema matches the transform; re-running on the same input is
   idempotent; empty input is handled without error.
3. Run `pytest` for the module's test file.
4. Report findings; do not modify code unless asked.
