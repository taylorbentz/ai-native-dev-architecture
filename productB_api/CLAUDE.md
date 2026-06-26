# productB_api

ProductB's backend API (TypeScript). Owns its own assistant capabilities in `.claude/`.

- **Build/verify:** `npm test`
- **Branch model:** trunk
- **Layout:** one file per route under `src/routes/`; the public contract lives in an OpenAPI spec.
- **Style:** 2-space indent, explicit return types on exported functions.
