# Repository Structure

The complete file tree of this illustration, annotated. Each top-level directory below would, in real
life, be its **own git repository**; they're collected here as folders so the whole pattern reads in
one place.

> For the *narrative* of how these pieces relate, see
> [`hub-repository/docs/ai-engineering/architecture-narrative.md`](hub-repository/docs/ai-engineering/architecture-narrative.md).
> For the design rationale of each directory, see
> [`hub-repository/docs/ai-engineering/repository-structure.md`](hub-repository/docs/ai-engineering/repository-structure.md).

## Top level

```
ai-native-dev-architecture/
├── README.md                  ← start here: the core idea
├── IMPLEMENTATION.md          ← how to adopt this on your own team, in phases
├── STRUCTURE.md               ← this file: the annotated tree
├── LICENSE                    ← MIT
├── .gitignore                 ← excludes generated/local artifacts (see below)
│
├── hub-repository/            ← the control plane + single launch point
├── productA_python/           ← a Python service / data pipeline
├── productA_terraform/        ← ProductA's infrastructure-as-code
├── productB_api/              ← ProductB's backend API (TypeScript)
├── productB_infra/            ← ProductB's infrastructure-as-code
└── productB_frontend/         ← ProductB's web UI (React/TypeScript)
```

## hub-repository/ — the control plane

The one repo a developer (or an unattended agent) launches the assistant from. It holds the canonical
configuration and composes in capabilities authored elsewhere.

```
hub-repository/
├── CLAUDE.md                              always-loaded operating context
├── .mcp.json.template                     tool-server recipe (rendered per-developer at setup)
└── .claude/
    ├── settings.json                      permissions + which hooks fire on which events
    ├── commands/                          single-file skills (invocable workflows)
    │   ├── ship.md                        build → commit → push → review
    │   ├── oncall.md                      triage incoming work (read-only by design)
    │   └── setup.md                       bootstrap a developer's workspace
    ├── skills/
    │   └── improve-assistant/             complex skill: edits the config itself
    │       ├── SKILL.md
    │       └── examples/                  templates for new skills/rules/hooks
    │           ├── skill-template.md
    │           ├── rule-template.md
    │           └── hook-template.sh
    ├── rules/                             guidance loaded on demand by file-path match
    │   ├── data-handling.md               paths: **/*.sql, **/*.py
    │   ├── commit-style.md                unconditional (loads every session)
    │   └── assistant-config-governance.md paths: .claude/**
    ├── hooks/                             scripts the harness runs automatically on events
    │   ├── session-start-state.sh         SessionStart → report each repo's state
    │   ├── validate-cwd.sh                PreToolUse  → block mis-targeted git commands
    │   ├── validate-style.sh              PostToolUse → check edits immediately
    │   └── check-uncommitted.sh           Stop        → warn about dirty repos
    └── agents/                            subagent specialists
        ├── sql-reviewer.md
        └── infra-diagnostician.md
```

It also contains the documentation set, which is the heart of the article:

```
hub-repository/docs/ai-engineering/
├── architecture-narrative.md      how the architecture works and why, in plain terms
├── repository-structure.md        per-directory design rationale + Mermaid diagram
├── prompts/
│   └── phase-rollout-prompt.md     a reusable prompt for rolling out config changes
└── research/
    └── capability-audit.md         worked example: scoring your own adoption
```

## Product repositories — federated authoring

Every product repo follows the **same shape**: a `.claude/` that is the source of truth for *its own*
skills/rules/hooks, and a `docs/<product>/` split into `prompts/` and `research/`.

```
productA_python/                    productB_api/
├── CLAUDE.md                       ├── CLAUDE.md
├── .claude/                        ├── .claude/
│   ├── commands/etl-validate.md    │   ├── commands/api-contract-check.md
│   ├── rules/python-conventions.md │   ├── rules/api-conventions.md
│   └── hooks/validate-python-…sh   │   └── hooks/validate-openapi.sh
├── src/etl/pipeline.py             ├── src/routes/health.ts
└── docs/productA/                  └── docs/productB/
    ├── prompts/etl-refactor-…md        ├── prompts/endpoint-scaffold-…md
    └── research/dataframe-…md          └── research/auth-model-…md
```

The other three (`productA_terraform`, `productB_infra`, `productB_frontend`) mirror this exactly, with
stack-appropriate skills, rules, and a sample source file. `productB_frontend` carries **two** rules
(`frontend-conventions.md` + `accessibility.md`) to show that a repo can scope several narrow rules to
the same file glob.

## What is intentionally NOT here

The `.gitignore` excludes things that are **generated per-developer** or **local-only** — so this repo
shows the *recipe*, not one person's resolved machine state:

| Excluded | Why |
|---|---|
| `**/.mcp.json` | Rendered from `.mcp.json.template` at setup with machine-specific paths/credentials |
| `**/.claude/settings.local.json` | Personal, per-developer tool grants |
| `hub-repository/.claude/commands/pa-*`, `pb-*` | Capabilities **composed up** from product repos at setup time (symlinks), not committed to the hub |
| `**/.venv/`, `**/node_modules/`, `**/.terraform/`, state files | Build/dependency output |

That last row is the important one conceptually: the `pa-*` / `pb-*` entries you see referenced in the
docs are **created at setup by linking each product repo's capability into the hub**. They live on a
developer's machine, not in version control — which is exactly the "federated authoring, centralized
composition" idea in practice.
