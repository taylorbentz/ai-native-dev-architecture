---
paths:
  - "**/*.ts"
---

# API Conventions

- 2-space indentation; explicit return types on exported functions.
- Every route is declared in the OpenAPI spec before a handler is written (spec-first).
- Validate and narrow all request input at the boundary; never trust client-supplied shapes.
- Return structured errors with a stable code; never leak stack traces to clients.
- Read configuration from the environment; no secrets in source.
