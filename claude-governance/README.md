# claude-governance

The team's **governance home** for the AI assistant. This repo is *authored and reviewed*, not launched
from. It does two jobs that nothing else can do:

1. **It is the source of the shared capability plugin.** Every reviewed skill, agent, hook, and
   cross-cutting rule the whole team relies on lives in [`plugin/`](plugin/) and is distributed as a
   versioned plugin. Developers enable the plugin once; updates reach everyone the next session. There
   are no symlinks and no per-repo copies to drift.

2. **It holds the estate map** — see [`estate/estate-map.json`](estate/estate-map.json). This is the one
   artifact that genuinely cannot live in any single repo or in a generic plugin: the assembled view of
   every repo, how each one deploys, the cross-account credential map, and how the repos depend on one
   another. The assistant reads it to find which repo holds a capability, to assemble a per-project
   working set, and to know the safety meaning of an action in each repo.

## Why this is separate from where developers work

Developers launch the assistant from the [`projects`](../projects/) repo, not here. Keeping the
governance home separate from the launch point means:

- Shared capability is **versioned and reviewed** like any release, instead of edited live.
- The estate map has a single owner and a single review trail.
- The thing developers work *from* stays focused on orchestrating work, not on holding config.

## Layout

```
claude-governance/
├── .claude-plugin/marketplace.json   how teammates discover + enable the plugin
├── plugin/                           the shared capability bundle (the plugin itself)
│   ├── .claude-plugin/plugin.json    plugin manifest (name, version)
│   ├── commands/                     shared skills: ship, oncall, setup
│   ├── agents/                       shared subagents: sql-reviewer, infra-diagnostician
│   ├── hooks/                        generic safety hooks (validate-cwd, validate-style, …) + hooks.json
│   ├── rules/                        cross-cutting rules: data-handling, commit-style, governance
│   ├── skills/improve-assistant/     the meta-skill: the one sanctioned way to change this repo
│   └── .mcp.json.template            tool-server recipe, rendered per-developer at setup
├── estate/
│   ├── estate-map.json               the assembled, estate-wide view (irreducible)
│   ├── repo-manifest.schema.md       the interface each repo implements
│   └── validate-estate-map.sh        CI check: map and repo manifests must agree
└── docs/ai-engineering/              the design narrative, workflow, and rationale
```

## Changing what's here

Use the `improve-assistant` skill (in the plugin) — it is the sanctioned way to edit any capability or
rule, and it keeps naming, metadata, and cross-references consistent. Every change is reviewed and then
released as a new plugin version, so the team moves forward together.
