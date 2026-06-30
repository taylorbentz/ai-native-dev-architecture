---
name: improve-assistant
description: Add or modify the team's assistant configuration (skills, rules, hooks, agents, settings) under one governance standard.
effort: max
allowed-tools: >
  Bash(find *)
  Bash(grep *)
  Read
  Edit
  Write
---

# /improve-assistant — Change the Configuration Itself

The sanctioned entry point for editing any skill, rule, hook, agent, or setting. The configuration is
code; this skill keeps it consistent as it grows.

## Where things go

| Primitive | Location | Format |
|---|---|---|
| Simple skill | `.claude/commands/<name>.md` | single file + frontmatter |
| Complex skill | `.claude/skills/<name>/SKILL.md` | folder + supporting files |
| Rule | `.claude/rules/<name>.md` | `paths:` frontmatter for file-scoped rules |
| Hook | `.claude/hooks/<name>.sh` | shell script, wired in `settings.json` |
| Agent | `.claude/agents/<name>.md` | subagent definition |

## Frontmatter standard (skills)

```yaml
---
name: <kebab-case>
description: <one line>
effort: <high|max>
allowed-tools: >
  <tool patterns>
---
```

## Process

1. Read the architecture docs in `docs/ai-engineering/` for current state.
2. Check existing primitives for contradiction **before** adding a new one.
3. When changing a fact stated in more than one place, grep for it everywhere and update **all**
   occurrences — stale contradictions cause wrong behavior:
   ```bash
   grep -rn "<keyword>" CLAUDE.md .claude/
   ```
4. Implement the change.
5. **Test hooks in isolation** before wiring them into `settings.json` — a bad hook can block all work.
6. Deliver with `/ship`.

## Templates

See `examples/` for `skill-template.md`, `rule-template.md`, and `hook-template.sh`.
