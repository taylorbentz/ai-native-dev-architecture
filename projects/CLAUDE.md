# projects — Operating Context

The assistant is launched from this repo by default. This file loads every session.

## Where things are

- **Shared capability** (skills, agents, hooks, rules) comes from the **governance plugin**, enabled in
  every session. Do not author shared capability here — change it in the `claude-governance` repo via
  the `improve-assistant` skill.
- **The estate map** lives in the governance repo at `estate/estate-map.json`. It lists every repo, what
  it does, how it deploys, and how repos depend on one another. Use it to decide which repos a task
  touches.
- **Product code** lives in the product repos, side by side in the workspace. Edit it in place; never
  copy it here.

## Starting work

1. Resume an existing project under `projects/<name>/`, or scaffold a new one with `/new-project`.
2. For a new project: research first (write findings to `research/`), then break the work into phases
   (one prompt per phase in `prompts/`), then execute phases with supervision, appending to
   `progress.log` as you go.
3. Assemble the working set from the estate map — pull in only the repos the project needs.

## Assembling a working set

When a task names a capability ("add a Python role capability", "adjust the reporting UI"), read the
estate map, match the capability to its repo, and follow `depends_on` / `provides_to` edges to find the
full set of repos the change will cascade through. Sequence the work along those edges (a dependency
before its dependents).

## Safety

A push means different things in different repos — the estate map's `branch_model_semantics` is the
source of truth. Confirm a repo's model before pushing. Treat anything that reaches production as gated;
prefer read-only operations; assume production unless proven otherwise.
