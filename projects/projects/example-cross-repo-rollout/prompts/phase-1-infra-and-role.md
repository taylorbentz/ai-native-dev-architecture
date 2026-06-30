# Phase 1 — Infrastructure + pipeline role

Depends on: nothing. Must complete before phases 2–4.

## Do

1. In `productA_terraform`, add the data role + read access for the new source the rollup needs. This
   repo is `dev-then-trunk` (main = production) — make the change on `dev`, open a review, and promote
   via the reviewed path. Do not push main directly.
2. In `productA_python`, add the pipeline logic that populates the rollup, using the new role. This repo
   is `trunk` — pushing deploys to staging only, so deliver normally with the `ship` skill.

## Done when

- The role exists and the pipeline writes the rollup data in staging.
- `progress.log` updated with what shipped and the review/promotion status of the infra change.
