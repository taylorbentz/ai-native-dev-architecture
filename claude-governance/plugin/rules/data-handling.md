---
paths:
  - "**/*.sql"
  - "**/*.py"
  - "**/migrations/**"
---

# Data Handling

Loads whenever the assistant touches query or data-processing code.

- Never hard-code identifiers for individual records or accounts in queries or scripts.
- Aggregate reporting output to a minimum group size; do not expose row-level data for small groups.
- Keep credentials and connection strings out of source — read them from the environment.
- Prefer parameterized queries; never build SQL by string concatenation of untrusted input.
