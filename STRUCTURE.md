# Repository Structure

The complete file tree of this illustration, annotated. Each top-level directory below would, in real
life, be its **own git repository**; they're collected here as folders so the whole pattern reads in
one place.

> For the *narrative* of how these pieces relate, see
> [`claude-governance/docs/ai-engineering/architecture-narrative.md`](claude-governance/docs/ai-engineering/architecture-narrative.md).
> For the design rationale of each directory, see
> [`claude-governance/docs/ai-engineering/repository-structure.md`](claude-governance/docs/ai-engineering/repository-structure.md).

## Two special repos, then the product repos

The setup splits the old "hub" into **two repos with different jobs**:

- **`claude-governance/`** — the *authored and reviewed* home for shared capability (shipped as a
  plugin) and for the estate map. Nobody launches the assistant from here.
- **`projects/`** — the *neutral launch point* every developer works from. Holds stateful projects and
  the session startup that pulls latest and loads the estate map.

```
ai-native-dev-architecture/
├── README.md                  ← start here: the core idea
├── WORKFLOW.md                ← a day in the life of a developer
├── IMPLEMENTATION.md          ← how to adopt this on your own team, in phases
├── STRUCTURE.md               ← this file: the annotated tree
├── LICENSE                    ← MIT
├── .gitignore                 ← excludes generated/local artifacts (see below)
│
├── claude-governance/         ← reviewed home for shared capability (a plugin) + the estate map
├── projects/                  ← the neutral launch point; holds stateful projects
│
├── productA_python/           ← a Python service / data pipeline
├── productA_terraform/        ← ProductA's infrastructure-as-code
├── productB_api/              ← ProductB's backend API (TypeScript)
├── productB_infra/            ← ProductB's infrastructure-as-code
└── productB_frontend/         ← ProductB's web UI (React/TypeScript)
```

## claude-governance/ — authored, reviewed, distributed as a plugin

```
claude-governance/
├── README.md
├── .claude-plugin/
│   └── marketplace.json                  how teammates discover + enable the plugin
├── plugin/                               the shared capability bundle (the plugin itself)
│   ├── .claude-plugin/plugin.json        plugin manifest (name, version)
│   ├── commands/                         shared skills: ship, oncall, setup
│   ├── agents/                           shared subagents: sql-reviewer, infra-diagnostician
│   ├── hooks/                            safety hooks + hooks.json wiring
│   │   ├── hooks.json                    wires the hooks via ${CLAUDE_PLUGIN_ROOT}
│   │   ├── validate-cwd.sh               PreToolUse  → block mis-targeted git commands
│   │   ├── validate-style.sh             PostToolUse → check edits immediately
│   │   └── check-uncommitted.sh          Stop        → warn about dirty repos
│   ├── rules/                            cross-cutting rules
│   │   ├── data-handling.md              paths: **/*.sql, **/*.py
│   │   ├── commit-style.md               unconditional
│   │   └── assistant-config-governance.md paths: .claude/**
│   ├── skills/improve-assistant/         the meta-skill: the one sanctioned way to change this repo
│   └── .mcp.json.template                tool-server recipe, rendered per-developer at setup
├── estate/
│   ├── estate-map.json                   the assembled, estate-wide view (irreducible)
│   └── repo-manifest.schema.md           the interface each repo implements
└── docs/ai-engineering/                  the design narrative, workflow, and rationale
    ├── architecture-narrative.md
    ├── repository-structure.md
    ├── prompts/phase-rollout-prompt.md
    └── research/capability-audit.md
```

Note what is **not** here: there is no `session-start-state.sh` that hardcodes the repo list. That data
lives in `estate/estate-map.json`, and the launch-point repo reads it. The plugin stays generic.

## projects/ — the neutral launch point

```
projects/
├── README.md
├── CLAUDE.md                             how the assistant behaves when launched here
├── .claude/
│   ├── settings.json                     wires the launch-point's own SessionStart hook
│   ├── commands/new-project.md           scaffold a stateful project
│   └── hooks/session-start.sh            pull latest governance, load estate map, report state
└── projects/                             one folder per stateful project
    └── example-cross-repo-rollout/
        ├── research/findings.md          what the assistant learned before planning
        ├── prompts/                      one self-contained prompt per phase
        │   ├── phase-1-infra-and-role.md
        │   └── phase-2-api-and-ui.md
        └── progress.log                  append-only record of cross-repo state
```

## Product repositories — own their capabilities, declare their facts

Every product repo follows the **same shape**: a `.claude/` that is the source of truth for *its own*
skills/rules/hooks, a `repo-manifest.json` declaring its facts to the estate map, and a
`docs/<product>/` split into `prompts/` and `research/`.

```
productA_python/                    productB_api/
├── CLAUDE.md                       ├── CLAUDE.md
├── repo-manifest.json              ├── repo-manifest.json
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

A repo's skill (e.g. `etl-validate.md`) is **not** copied anywhere. The assistant picks it up when that
repo is in the working set. There are no `pa-`/`pb-` prefixed links anymore — that was the old
symlink-into-a-hub model, now replaced by the plugin (for shared capability) plus per-repo manifests
(for repo-specific facts).

## What is intentionally NOT here

The `.gitignore` excludes things that are **generated per-developer** or **local-only** — so this repo
shows the *recipe*, not one person's resolved machine state:

| Excluded | Why |
|---|---|
| `**/.mcp.json` | Rendered from `.mcp.json.template` at setup with machine-specific paths/credentials |
| `**/.claude/settings.local.json` | Personal, per-developer tool grants |
| `**/.venv/`, `**/node_modules/`, `**/.terraform/`, state files | Build/dependency output |

Shared capability is no longer "composed up" by copying or symlinking — it is installed as a versioned
plugin from `claude-governance/`, so it is always single-sourced and never drifts.
