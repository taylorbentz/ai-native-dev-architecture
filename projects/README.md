# projects

**This is where developers launch the assistant and do their work — every session, by default.**

It is deliberately *not* one of the product code repos. It is neutral ground. A change usually spans
several repos and there is no single "right" code repo to start from, so work begins here, from one
consistent home.

## What this repo is for

1. **A consistent launch point.** Starting the assistant is one habit, from one place, with the same
   reviewed setup every time — regardless of which repos the day's work will touch.

2. **A home for stateful projects.** Real work is multi-step and outlives a single session. Each project
   gets a folder under [`projects/`](projects/) with its own research, phased prompts, and a running
   progress log. Because the home is fixed and known, any teammate can find a project, see its state,
   and pick it up. Project state stops scattering across random code repos.

3. **The place the working set is assembled.** On launch, the assistant reads the team's estate map
   (published by the [`claude-governance`](../claude-governance/) repo) and pulls only the handful of
   repos a given project actually needs into its working set. You describe the intent; the assistant
   uses the map to find the repos.

## What this repo is NOT

- It is **not** the home of shared skills/rules/hooks — those come from the governance plugin, enabled
  in every session.
- It is **not** where product code lives — that's in the product repos, which this session edits in
  place.

## Layout

```
projects/
├── CLAUDE.md                     how the assistant behaves when launched here
├── .claude/
│   ├── commands/
│   │   └── new-project.md        scaffold a stateful project (research → prompts → log)
│   └── hooks/
│       └── session-start.sh      pull latest, load the estate map, report state
└── projects/                     one folder per stateful project
    └── example-cross-repo-rollout/
        ├── research/             what the assistant learned before planning
        ├── prompts/              one self-contained prompt per phase
        └── progress.log          append-only record of what happened
```

## A day, in short

You launch from here. The session pulls the latest governance plugin and estate map, then reports the
state of the repos you're working in. You either resume a project under `projects/` or scaffold a new
one, let the assistant research it and write phased prompts, then execute those phases with supervision.
Delivery, review, and triage are handled by the shared skills from the governance plugin. See
[`../claude-governance/docs/ai-engineering/WORKFLOW.md`](../claude-governance/docs/ai-engineering/) for
the full cycle.
