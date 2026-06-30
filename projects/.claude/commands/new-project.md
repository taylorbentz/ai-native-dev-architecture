---
name: new-project
description: Scaffold a stateful project — research, phased prompts, and a progress log — under projects/.
effort: high
allowed-tools: >
  Read
  Write
  Bash(ls *)
  Bash(git -C *)
---

# /new-project — Start a Stateful Project

Creates a durable home for a multi-step piece of work, so it survives across sessions and is findable by
anyone on the team.

## Procedure

1. **Name it.** Create `projects/<kebab-name>/` with `research/`, `prompts/`, and an empty
   `progress.log`.

2. **Research before planning.** Investigate the problem across the repos it touches — use the estate
   map (governance repo, `estate/estate-map.json`) to find which repos are involved. Write findings to
   `research/`: how the relevant code works today, what must change in each repo, the risks, and the
   order the changes must happen in. Stop and let the developer correct course.

3. **Write phased prompts.** Break the work into phases — typically one phase per repo or per logical
   step, sequenced along the dependency edges. Write one self-contained prompt per phase into
   `prompts/`, named `phase-1-*.md`, `phase-2-*.md`, … Each prompt should be runnable on its own.

4. **Execute with supervision.** Work the phases in order. After each phase, append a short entry to
   `progress.log` (what changed, what shipped, what's next). Deliver code with the shared `ship` skill.

## Why this shape

Research, then plan, then execute — kept separate on purpose, so thinking is finished before building.
The folder is the durable holder of the cross-repo overview, not the live session: if the session ends,
the next one resumes from `research/`, `prompts/`, and `progress.log` with the full picture intact.
