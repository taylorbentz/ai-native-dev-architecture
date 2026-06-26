---
paths:
  - "**/*.tf"
---

# Terraform Patterns

- One concern per module; expose inputs via `variables.tf`, outputs via `outputs.tf`.
- Name resources for what they are, not where they sit.
- Pin provider versions. Never hard-code secrets — use variables and a secrets backend.
- Treat `destroy`/`replace` in a plan as requiring explicit human confirmation.
- Run `terraform fmt` before committing.
