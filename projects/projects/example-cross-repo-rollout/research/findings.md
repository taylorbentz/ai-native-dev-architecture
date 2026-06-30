# Research: Add a new "regional rollup" reporting capability

**Status:** research complete, ready to plan.

## The ask

Add a new regional rollup to the reporting surface. Sounds like one change to the UI. It is not — it
cascades across four repos.

## What the estate map tells us

Tracing the capability and its dependency edges:

| Step | Repo | Why it's involved |
|---|---|---|
| 1 | `productA_terraform` | The new rollup needs a data role with read access to a new source. Infra + IAM first. |
| 2 | `productA_python` | The pipeline role logic that populates the rollup depends on that infra. |
| 3 | `productB_api` | A new transformation + endpoint exposes the rollup. Depends on the pipeline output. |
| 4 | `productB_frontend` | The UI reads the new endpoint. Depends on the API. |

## The order matters

The dependency edges (`depends_on` in the estate map) force the sequence: infra before the role that
uses it, pipeline before the transformation that reads it, API before the UI that calls it. Doing these
in the wrong order produces broken intermediate states.

## Safety notes (from the estate map)

- `productA_terraform` and `productB_infra` are `dev-then-trunk` — main is production. Promote via the
  reviewed path, never a direct push.
- `productA_python`, `productB_api`, `productB_frontend` are `trunk` — main deploys to staging only,
  production is gated separately. Safe to push.

## Risk

The cross-account boundary (app accounts vs. data accounts) means step 1 and step 3 deploy into
different account families. The working set must carry both credential profiles.
