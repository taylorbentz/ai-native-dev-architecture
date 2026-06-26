---
paths:
  - "**/*.tsx"
---

# Frontend Conventions

- 2-space indentation; typed function components with an explicit props interface.
- One component per file; co-locate its test and styles.
- Keep state local unless it is genuinely shared; lift it only when needed.
- No business logic in components — put it in plain functions that are easy to test.
