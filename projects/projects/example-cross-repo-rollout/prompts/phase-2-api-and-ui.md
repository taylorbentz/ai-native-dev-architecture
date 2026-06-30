# Phase 2 — Transformation, endpoint, and UI

Depends on: Phase 1 (the rollup data must exist).

## Do

1. In `productB_api`, add the transformation that shapes the rollup and the endpoint that serves it.
   Spec-first (see the repo's API conventions). `trunk` repo — deliver normally.
2. In `productB_frontend`, add the UI that reads the new endpoint. Keep the accessibility baseline.
   `trunk` repo — deliver normally.

## Done when

- The rollup is visible end to end in staging.
- Each repo's change is delivered through the `ship` skill and has an open review.
- `progress.log` records the endpoint shape and any follow-ups before production promotion.
