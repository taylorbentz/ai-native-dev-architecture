# Implementing This On Your Team

This repo shows the *shape* of an AI-native development setup. This guide is the *path* to get there —
ordered so you see value on day one and never take a risky step before a safe one.

> **Golden rule of ordering:** add capability that can only *help* before any control that can *block*.
> Rules, docs, and skills are additive — worst case they're ignored. Hooks and permissions can halt all
> work if misconfigured. So they come last, and only after you've tested them in isolation.

The phases map onto the primitives in this repo. You do **not** need a multi-repo estate to start — a
single repository benefits from Phases 1–3 immediately. The two-repo model (governance + launch point,
Phase 4+) only pays off once you have several repos.

---

## Phase 0 — Prerequisites

- An AI coding assistant that supports **file-based configuration** (committed instructions, file-scoped
  rules, event hooks, and subagents). The exact product doesn't matter; the pattern is portable.
- A place to keep shared config. Early on this is just one repo's `.claude/`. Once you have several
  repos (Phase 4) it becomes a dedicated governance repo. Start wherever you are.
- Agreement from the team that **assistant config is code** — it lands via the same review process as
  everything else. This social contract matters more than any file below.

---

## Phase 1 — Capture what's already in people's heads (zero risk)

Goal: stop re-explaining the same context to the assistant in every session.

1. Write a **`CLAUDE.md`** (or your tool's equivalent always-on context file) at the repo root: build
   command, test command, branch model, "how we deliver." Keep it short — this loads every session.
2. Convert recurring "please always…" corrections into **file-scoped rules** under `.claude/rules/`.
   Scope each to the files it governs so it loads only when relevant:
   - `python-conventions.md` → `paths: **/*.py`
   - `terraform-patterns.md` → `paths: **/*.tf`
   See [`productA_python/.claude/rules/`](productA_python/.claude/rules/) for the pattern.

**Why first:** purely additive. Nothing can break. You'll feel the assistant "get" your codebase
immediately, which builds the team's appetite for the rest.

---

## Phase 2 — Turn repeated workflows into skills (zero risk)

Goal: one-command, consistent versions of the things you do over and over.

1. Identify your top 3 repeated multi-step workflows (delivering a change, triaging an alert, scaffolding
   a component).
2. Write each as a **skill** in `.claude/commands/`. Start with the delivery workflow — see
   [`claude-governance/plugin/commands/ship.md`](claude-governance/plugin/commands/ship.md).
3. Give each skill a clear **boundary** section ("what this will NOT do"). The
   [`oncall`](claude-governance/plugin/commands/oncall.md) skill is a good model: it diagnoses but never
   mutates production.

**Why now:** still additive, and skills are where the daily time savings live — this is what converts
skeptics.

---

## Phase 3 — Add safety nets with hooks (HIGHER risk — test first)

Goal: catch mistakes the instant they happen, deterministically, instead of relying on the model to
remember.

The hooks split by where they belong. The **generic** ones ship in the governance plugin
([`claude-governance/plugin/hooks/`](claude-governance/plugin/hooks/)); the **launch-point** one that
reads the estate map lives in the projects repo
([`projects/.claude/hooks/`](projects/.claude/hooks/)):

| Hook | Fires | Does | Lives in |
|---|---|---|---|
| `session-start.sh` | session start | pull latest governance, load estate map, report state | projects repo |
| `validate-cwd.sh` | before a command | blocks git commands that target the wrong repo | plugin |
| `validate-style.sh` | after an edit | flags style issues immediately | plugin |
| `check-uncommitted.sh` | session end | warns about work the delivery flow would discard | plugin |

A hook that needs estate knowledge (the repo list, who deploys where) reads the **estate map** rather
than hardcoding it — that keeps the shared plugin generic and reusable.

**Test-before-wire protocol (do not skip):**
1. Write the hook to log its input to a temp file and exit 0 (allow everything).
2. Trigger it; inspect the logged input so you know the real data shape.
3. Add the real logic; test it against your common workflows so it doesn't block legitimate work.
4. Only then wire it in (plugin hooks via `hooks.json`, launch-point hooks via `settings.json`).

**Rollback:** remove the hook's entry from its wiring file. A bad hook is the one thing here that can
stop all work — which is exactly why this phase is gated behind the additive ones.

---

## Phase 4 — Go multi-repo: split governance from the launch point (medium risk)

Only do this once you have several repos worth governing together. The single repo you've been adding to
now splits into two repos with distinct jobs.

1. **Make a governance repo** ([`claude-governance/`](claude-governance/)). Move the shared skills,
   agents, hooks, and rules into a **plugin** there and publish it through a marketplace
   ([`.claude-plugin/marketplace.json`](claude-governance/.claude-plugin/marketplace.json)). Developers
   enable the plugin once; updates arrive by version bump. This replaces any copying or symlinking — the
   reason the old "compose capabilities up into a hub" step is gone.

2. **Write the estate map** ([`estate/estate-map.json`](claude-governance/estate/estate-map.json)) — the
   one artifact that can't live in any single repo: every repo, how each deploys, the cross-account
   credential map, and the dependency edges between repos. Have each product repo declare its own facts
   in a [`repo-manifest.json`](claude-governance/estate/repo-manifest.schema.md); the estate map is their
   aggregation. Add a CI check
   ([`validate-estate-map.sh`](claude-governance/estate/validate-estate-map.sh)) so the map and the
   manifests can't silently drift apart — that's the one consistency risk this split introduces, and a
   five-second check removes it.

3. **Make a launch-point repo** ([`projects/`](projects/)) — neutral ground developers work from. It
   holds stateful projects and a `session-start` hook that pulls the latest governance and loads the
   estate map. Keep repo-specific skills/rules **in their own repos**; the assistant picks them up when
   that repo is in the working set.

**Why two repos, not one hub:** governance is *authored and reviewed* (and shouldn't be edited live),
while the launch point is *worked from every day*. Splitting them keeps shared capability versioned and
the daily workspace focused on orchestrating work. The only thing that must be centralized is the estate
map — everything else is either a plugin (shared) or stays in its home repo (specific).

---

## Phase 5 — Connect live systems with local tool servers (medium risk)

Goal: let the assistant read real state (tickets, metrics, docs) safely.

1. Run small **tool servers locally**, wired in via a **gitignored manifest** rendered from a committed
   template — see [`claude-governance/plugin/.mcp.json.template`](claude-governance/plugin/.mcp.json.template).
2. Launch them **read-only by default** and **scope each to one environment** via a named credential
   profile, so a server pointed at staging physically cannot reach production.
3. Graduate to a **hosted** shared server only when something *other than a person at a keyboard* needs
   the tool (e.g. a scheduled agent). Local servers can't serve an unattended caller — that's the signal
   you've outgrown them.

---

## Phase 6 — Self-governance and autonomy (ongoing)

Goal: let the configuration evolve safely, and let safe work happen unattended.

1. Add a **meta-skill** that is the one sanctioned way to change the config, encoding your own standards
   — see [`improve-assistant`](claude-governance/plugin/skills/improve-assistant/SKILL.md). Pair it with
   a rule that makes any edit to the config load those standards first.
2. **Audit your own adoption** periodically against the tool's full feature surface; treat
   under-utilization as a backlog. Worked example:
   [`capability-audit.md`](claude-governance/docs/ai-engineering/research/capability-audit.md).
3. Introduce **scheduled / headless runs** only for workflows with a hard read-only boundary (triage
   that comments but never mutates). Scope autonomy narrowly and widen it as trust builds.

---

## The progression

Each phase delivers something you can feel before the next begins. The pace depends on your team's size
and the complexity of your estate, so treat these as an order, not a schedule.

| Phases | What changes for the team |
|---|---|
| 1–2 | The assistant understands your repo and runs your common workflows the same way every time. |
| 3 | It catches mistakes the moment they happen, instead of at build time. |
| 4–5 | One neutral launch point covers every repo, with safe access to live system state. |
| 6 | The setup improves itself through review, and safe routine work can run unattended. |

Start at Phase 1. Don't jump to hooks or the two-repo split until the additive layers are paying off —
the ordering *is* the method.

Once you reach Phase 4, see [`WORKFLOW.md`](WORKFLOW.md) for what the resulting day-to-day cycle looks
like for an engineer.
