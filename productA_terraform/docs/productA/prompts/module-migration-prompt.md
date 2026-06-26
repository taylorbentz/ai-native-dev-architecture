# Prompt: Migrate a Resource into a Module

> Extract the inline resources in `<file>.tf` into a reusable module under `modules/<name>/`, exposing
> inputs via `variables.tf` and results via `outputs.tf`. Produce a `terraform plan` afterward and
> confirm it shows **no** destroy/replace — a clean refactor should be a no-op to real infrastructure.
