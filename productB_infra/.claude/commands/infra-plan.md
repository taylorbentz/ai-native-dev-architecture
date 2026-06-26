---
name: infra-plan
description: Produce and explain a terraform plan in plain language, flagging destructive changes.
effort: high
allowed-tools: >
  Read
  Bash(terraform *)
---

# /infra-plan — Plan & Explain

Composed into the hub as `pb-infra-plan`.

## Procedure

1. `terraform fmt -check` then `terraform validate`.
2. `terraform plan -no-color`.
3. Summarize in plain language: what is created / changed / **destroyed**.
4. Call out any destroy or replace explicitly and ask for confirmation before anyone applies.
