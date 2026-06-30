# AI-Native Development Architecture (Illustrative)

A reference layout for running an AI coding assistant as **version-controlled infrastructure** across
many repositories — shared capability distributed as a plugin, governed in one place, and used from one
consistent launch point.

> **This is an illustration.** Every repo, skill, rule, and hook here is invented for teaching.
> It accompanies a write-up on treating your AI assistant's configuration as code. Nothing here is
> tied to any company, product, or proprietary system.

## What this repo represents

In real life, each top-level directory below would be its **own** git repository. They're collected
here as plain folders so the whole pattern can be read in one place.

| Directory | Stands for | Role |
|---|---|---|
| `claude-governance/` | Reviewed home for shared capability + the estate map | authored, not launched from |
| `projects/` | The neutral launch point developers work from | holds stateful projects |
| `productA_python/` | A Python service / data pipeline | product repo |
| `productA_terraform/` | ProductA's infrastructure-as-code | product repo |
| `productB_api/` | ProductB's backend API | product repo |
| `productB_infra/` | ProductB's infrastructure-as-code | product repo |
| `productB_frontend/` | ProductB's web UI | product repo |

## The core idea

- **Shared capability is a plugin.** The skills, agents, hooks, and rules the whole team relies on live
  in `claude-governance/` and ship as a versioned plugin. Enable it once; updates reach everyone. No
  copying, no symlinks, no drift.
- **Each repo declares its own facts.** A `repo-manifest.json` in each product repo states how it builds,
  how it deploys, and what it depends on. Generic shared capability reads those facts instead of
  hard-coding them.
- **One thing can't decentralize: the estate map.** `claude-governance/estate/estate-map.json` is the
  assembled view of every repo and how they connect. It can't live in any single repo, and a generic
  plugin can't carry it — so it has one governed home.
- **Developers launch from one neutral place.** Work starts in `projects/`, not in a product repo. A
  change usually spans several repos and there's no single "right" one to start from. Stateful projects
  live here too, so work is findable and resumable.

```
        ┌──────────────────────────┐        ┌──────────────────────────┐
        │     claude-governance     │        │         projects          │
        │  • shared plugin (skills, │        │  • where developers launch │
        │    hooks, rules, agents)  │        │  • stateful projects:      │
        │  • estate map (the one    │──────► │    research → prompts →    │
        │    cross-cutting artifact)│ plugin │    progress.log            │
        └──────────────────────────┘ + map  └────────────┬──────────────┘
                                                          │ assembles a working set
                                                          ▼ from the estate map
        ┌───────────┬───────────────┬───────────┬────────────┬──────────────┐
      productA_    productA_     productB_   productB_    productB_
       python      terraform        api        infra       frontend
        (each owns its own .claude/ + declares repo-manifest.json)
```

## Where to go next

| If you want to… | Read |
|---|---|
| Understand *how it works and why*, in plain terms | [`architecture-narrative.md`](claude-governance/docs/ai-engineering/architecture-narrative.md) |
| See what a *day of development* actually looks like | [`WORKFLOW.md`](WORKFLOW.md) |
| **Actually adopt this on your team** | [`IMPLEMENTATION.md`](IMPLEMENTATION.md) — a phased, low-risk-first rollout |
| See the *full annotated file tree* | [`STRUCTURE.md`](STRUCTURE.md) |
| Understand each directory's *design rationale* | [`repository-structure.md`](claude-governance/docs/ai-engineering/repository-structure.md) |

## License

[MIT](LICENSE) — illustrative content, free to copy and adapt.
