---
name: ship
description: Build, verify, commit, push, and open a review for every modified repo.
effort: high
allowed-tools: >
  Bash(git -C *)
  Read
  Edit
---

# /ship — Deliver Changes

The single delivery workflow. Never run commit/push/review as separate manual steps.

## Procedure

1. **Detect modified repos.** For each product repo, run `git -C <repo> status --porcelain`.
   Build the list of repos with changes.

2. **Build & verify each modified repo.** Run that repo's verification command (see its CLAUDE.md):
   - Python repo: `pytest`
   - Terraform repo: `terraform fmt -check && terraform validate`
   - TypeScript repo: `npm test`

   Stop and report if any verification fails. Do not commit broken code.

3. **Commit per repo.** Each repo is its own git repository — one commit each, targeted with `git -C`:
   ```bash
   git -C <repo> add <files>
   git -C <repo> commit -m "<summary>"
   ```

4. **Push** to the repo's working branch.

5. **Open a review** for each pushed branch and report the links back to the developer.

## Notes

- Respect each repo's branch model (some push to `dev` first, some to `trunk`).
- Avoid trunk pushes on Fridays/weekends unless the developer explicitly confirms.
