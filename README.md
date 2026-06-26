# AI-Native Development Architecture (Illustrative)

A reference layout for running an AI coding assistant as **version-controlled infrastructure** across a
polyrepo — many independent repositories governed from one control plane.

> **This is an illustration.** Every repo, skill, rule, and hook here is invented for teaching.
> It accompanies a write-up on treating your AI assistant's configuration as code. Nothing here is
> tied to any company, product, or proprietary system.

## What this repo represents

In real life, each top-level directory below would be its **own** git repository. They're collected
here as plain folders so the whole pattern can be read in one place.

| Directory | Stands for | Stack |
|---|---|---|
| `hub-repository/` | The control plane + single launch point | docs + config only |
| `productA_python/` | A Python service / data pipeline | Python |
| `productA_terraform/` | ProductA's infrastructure-as-code | Terraform |
| `productB_api/` | ProductB's backend API | TypeScript |
| `productB_infra/` | ProductB's infrastructure-as-code | Terraform |
| `productB_frontend/` | ProductB's web UI | TypeScript/React |

## The core idea

- **One launch point.** A developer (or an unattended agent) starts the assistant from the **hub**,
  regardless of which repo they're editing.
- **Federated authoring.** Each product repo owns the skills/rules/hooks that fit *its* code, in its
  own `.claude/` directory.
- **Centralized composition.** A setup step links each repo's capabilities *up* into the hub, tagged
  with a provenance prefix (`pa-`, `pb-`) so you can always tell who owns what.
- **Configuration as code.** Skills, rules, hooks, agents, and settings are committed files — reviewed,
  diffed, and shared like any other code.

```
            ┌─────────────────────────────┐
            │       hub-repository         │  ← launch the assistant here
            │  .claude/  +  docs/          │
            └──────────────┬───────────────┘
              reaches down  │  ▲  capabilities linked up
              to do work    ▼  │  (pa-* , pb-*)
   ┌────────────┬───────────┴───────┬────────────┬──────────────┐
 productA_    productA_         productB_     productB_      productB_
  python      terraform           api          infra         frontend
```

## Where to go next

| If you want to… | Read |
|---|---|
| Understand the *what & why* | [`architecture-narrative.md`](hub-repository/docs/ai-engineering/architecture-narrative.md) — eight distinctive attributes |
| See the *full annotated file tree* | [`STRUCTURE.md`](STRUCTURE.md) |
| Understand each directory's *design rationale* | [`repository-structure.md`](hub-repository/docs/ai-engineering/repository-structure.md) |
| **Actually adopt this on your team** | [`IMPLEMENTATION.md`](IMPLEMENTATION.md) — a phased, low-risk-first rollout |

## License

[MIT](LICENSE) — illustrative content, free to copy and adapt.
