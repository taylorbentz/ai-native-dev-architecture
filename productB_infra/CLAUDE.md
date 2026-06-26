# productB_infra

Infrastructure-as-code for ProductB. Owns its own assistant capabilities in `.claude/`.

- **Verify:** `terraform fmt -check && terraform validate`
- **Branch model:** `dev` → `trunk` (promote after validation)
- **Layout:** reusable modules under `modules/`; one concern per module.
- Never commit state files or `.terraform/`.
