---
name: api-contract-check
description: Check that route handlers match the declared API contract, with no undocumented endpoints.
effort: high
allowed-tools: >
  Read
  Bash(npm *)
---

# /api-contract-check — Contract Conformance

This skill lives in the repo it serves. The assistant picks it up when this repo is in the working set —
no copying or linking into a central location.

## Procedure

1. Read the OpenAPI spec and the handlers under `src/routes/`.
2. Verify every route has a spec entry and every spec entry has a handler (no drift either direction).
3. Check request/response shapes match the spec.
4. Run `npm test`.
5. Report mismatches as a table: route, issue, suggested fix. Do not modify code unless asked.
