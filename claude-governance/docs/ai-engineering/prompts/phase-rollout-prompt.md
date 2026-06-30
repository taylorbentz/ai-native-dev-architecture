# Prompt: Roll Out a Configuration Phase

A reusable prompt. Paste into a fresh assistant session to implement one phase of a config rollout.

---

You are improving this repository's AI assistant configuration. Implement **one** phase at a time,
lowest-risk first.

1. Read `docs/ai-engineering/architecture-narrative.md` and `repository-structure.md` for current state.
2. Read the phase description I provide below.
3. **Research all open questions before writing anything.** If a phase touches hooks, test the hook in
   isolation (log its input JSON to a temp file, trigger it, inspect) before wiring it into settings.
4. Implement the change as committed primitives following `/improve-assistant` standards.
5. Verify: invoke any new skill; read a file matching any new rule's glob; dry-run any new hook.
6. Summarize what changed and how to roll it back.

Phase to implement:

> _(paste the phase description here)_

Order phases: additive/low-risk (rules, docs, frontmatter) first; behavior-restricting (permissions)
and hooks last, because a misconfigured hook can block all work.
