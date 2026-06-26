---
name: component-new
description: Scaffold a new UI component — typed props, co-located test, and accessibility baseline.
effort: high
allowed-tools: >
  Read
  Write
  Bash(npm *)
---

# /component-new — Scaffold a Component

Composed into the hub as `pb-frontend-component-new`.

## Procedure

1. Create `src/components/<Name>.tsx` as a typed function component with an explicit props interface.
2. Co-locate `<Name>.test.tsx` with a basic render test.
3. Apply the accessibility baseline (labels, roles, keyboard focus).
4. Run `npm test` and `npm run lint`; report results.
