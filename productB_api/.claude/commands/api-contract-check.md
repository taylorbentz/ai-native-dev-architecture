---
name: api-contract-check
description: Check that route handlers match the declared API contract, with no undocumented endpoints.
effort: high
allowed-tools: >
  Read
  Bash(npm *)
---

# /api-contract-check — Contract Conformance

Composed into the hub as `pb-api-contract-check`.

## Procedure

1. Read the OpenAPI spec and the handlers under `src/routes/`.
2. Verify every route has a spec entry and every spec entry has a handler (no drift either direction).
3. Check request/response shapes match the spec.
4. Run `npm test`.
5. Report mismatches as a table: route, issue, suggested fix. Do not modify code unless asked.
