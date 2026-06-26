# Hub Repository — Assistant Operating Rules

The AI assistant is **always launched from this repository**, even when the work happens in another
repo. This file loads on every session as shared, always-on context.

## Workspace layout

`<WORKSPACE>` is the directory that contains all the product repos side by side. Resolve it relative
to wherever this hub is checked out. Every product repo is its own git repository with its own build,
branch model, and review process — commit to each separately.

| Repo | Stack | Branch model |
|---|---|---|
| hub-repository | docs + config | trunk |
| productA_python | Python | trunk |
| productA_terraform | Terraform | dev → trunk |
| productB_api | TypeScript | trunk |
| productB_infra | Terraform | dev → trunk |
| productB_frontend | TypeScript/React | trunk |

## Command targeting

The shell resets the working directory between commands. Any command that *modifies* a repo must
target that repo's directory explicitly:

```bash
git -C <WORKSPACE>/productA_python add <files>
git -C <WORKSPACE>/productA_python commit -m "message"
```

Read-only commands (`git status`, `git log`, `ls`, `grep`) need no targeting.

## Delivering changes

Use the `/ship` skill to deliver code — it builds, verifies, commits, pushes, and opens a review for
every modified repo in one flow. Don't run commit/push/review as separate manual steps.

## Safety defaults

- Assume a resource is production unless clearly proven otherwise; prefer read-only operations.
- Never disable a safety control (branch protection, required review) without explicit confirmation.
- Avoid trunk pushes and production promotions on Fridays or weekends.
