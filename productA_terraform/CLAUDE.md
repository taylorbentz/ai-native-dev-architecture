# productA_terraform

Infrastructure-as-code for ProductA. Owns its own assistant capabilities in `.claude/`.

- **Verify:** `terraform fmt -check && terraform validate`
- **Branch model:** `dev` → `trunk` (promote after validation)
- **Layout:** reusable modules under `modules/`; one concern per module.
- Never commit state files or `.terraform/`.
