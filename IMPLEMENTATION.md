# Implementing This On Your Team

This repo shows the *shape* of an AI-native development setup. This guide is the *path* to get there —
ordered so you see value on day one and never take a risky step before a safe one.

> **Golden rule of ordering:** add capability that can only *help* before any control that can *block*.
> Rules, docs, and skills are additive — worst case they're ignored. Hooks and permissions can halt all
> work if misconfigured. So they come last, and only after you've tested them in isolation.

The phases map onto the primitives in this repo. You do **not** need a multi-repo estate to start — a
single repository benefits from Phases 1–3 immediately. The hub/composition model (Phase 4+) only pays
off once you have several repos.

---

## Phase 0 — Prerequisites (½ day)

- An AI coding assistant that supports **file-based configuration** (committed instructions, file-scoped
  rules, event hooks, and subagents). The exact product doesn't matter; the pattern is portable.
- A repo to act as the **hub**. If you have one estate-central repo, use it. If you have exactly one
  repo, *it* is the hub.
- Agreement from the team that **assistant config is code** — it lands via the same review process as
  everything else. This social contract matters more than any file below.

---

## Phase 1 — Capture what's already in people's heads (1–2 days, zero risk)

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

## Phase 2 — Turn repeated workflows into skills (2–4 days, zero risk)

Goal: one-command, consistent versions of the things you do over and over.

1. Identify your top 3 repeated multi-step workflows (delivering a change, triaging an alert, scaffolding
   a component).
2. Write each as a **skill** in `.claude/commands/`. Start with the delivery workflow — see
   [`hub-repository/.claude/commands/ship.md`](hub-repository/.claude/commands/ship.md).
3. Give each skill a clear **boundary** section ("what this will NOT do"). The
   [`oncall`](hub-repository/.claude/commands/oncall.md) skill is a good model: it diagnoses but never
   mutates production.

**Why now:** still additive, and skills are where the daily time savings live — this is what converts
skeptics.

---

## Phase 3 — Add safety nets with hooks (3–5 days, HIGHER risk — test first)

Goal: catch mistakes the instant they happen, deterministically, instead of relying on the model to
remember.

Each hook in this repo's [`hub-repository/.claude/hooks/`](hub-repository/.claude/hooks/) maps to a
lifecycle event:

| Hook | Fires | Does |
|---|---|---|
| `session-start-state.sh` | session start | reports each repo's branch/dirtiness; warns on weekends |
| `validate-cwd.sh` | before a command | blocks git commands that target the wrong repo |
| `validate-style.sh` | after an edit | flags style issues immediately |
| `check-uncommitted.sh` | session end | warns about work the delivery flow would discard |

**Test-before-wire protocol (do not skip):**
1. Write the hook to log its input to a temp file and exit 0 (allow everything).
2. Trigger it; inspect the logged input so you know the real data shape.
3. Add the real logic; test it against your common workflows so it doesn't block legitimate work.
4. Only then wire it into `settings.json`.

**Rollback:** remove the hook's entry from `settings.json`. A bad hook is the one thing here that can
stop all work — which is exactly why this phase is gated behind the additive ones.

---

## Phase 4 — Go multi-repo: the hub and composition (1 week, medium risk)

Only do this once you have several repos worth governing together.

1. Designate the **hub** and write a **`/setup`** skill (see
   [`hub-repository/.claude/commands/setup.md`](hub-repository/.claude/commands/setup.md)) that a new
   developer runs once.
2. Author each repo's capabilities **in that repo** (federated authoring). Have `/setup` **compose them
   up** into the hub — symlink each product repo's skill into the hub's commands directory with a
   **provenance prefix** (`pa-`, `pb-`) so ownership stays legible.
3. Gitignore the composed links and the generated tool-server config — they're per-machine, not
   committed. See this repo's [`.gitignore`](.gitignore).

**The tradeoff to decide deliberately** (covered at the end of
[`architecture-narrative.md`](hub-repository/docs/ai-engineering/architecture-narrative.md)): symlink for
single-sourcing (no drift, but links are local) vs. vendor copies into the hub (full history, but they
can drift). If you vendor, add a periodic check that flags divergence.

---

## Phase 5 — Connect live systems with local tool servers (varies, medium risk)

Goal: let the assistant read real state (tickets, metrics, docs) safely.

1. Run small **tool servers locally**, wired in via a **gitignored manifest** rendered from a committed
   template — see [`hub-repository/.mcp.json.template`](hub-repository/.mcp.json.template).
2. Launch them **read-only by default** and **scope each to one environment** via a named credential
   profile, so a server pointed at staging physically cannot reach production.
3. Graduate to a **hosted** shared server only when something *other than a person at a keyboard* needs
   the tool (e.g. a scheduled agent). Local servers can't serve an unattended caller — that's the signal
   you've outgrown them.

---

## Phase 6 — Self-governance and autonomy (ongoing)

Goal: let the configuration evolve safely, and let safe work happen unattended.

1. Add a **meta-skill** that is the one sanctioned way to change the config, encoding your own standards
   — see [`improve-assistant`](hub-repository/.claude/skills/improve-assistant/SKILL.md). Pair it with a
   rule that makes any edit to `.claude/**` load those standards first.
2. **Audit your own adoption** periodically against the tool's full feature surface; treat
   under-utilization as a backlog. Worked example:
   [`capability-audit.md`](hub-repository/docs/ai-engineering/research/capability-audit.md).
3. Introduce **scheduled / headless runs** only for workflows with a hard read-only boundary (triage
   that comments but never mutates). Scope autonomy narrowly and widen it as trust builds.

---

## A realistic timeline

| Week | Phases | You'll feel |
|---|---|---|
| 1 | 1–2 | "The assistant finally understands our repo and our workflows." |
| 2 | 3 | "It catches my mistakes before the build does." |
| 3–4 | 4–5 | "One launch point, every repo, live system state — safely." |
| Ongoing | 6 | "The setup improves itself, and routine triage runs without me." |

Start at Phase 1 this week. Don't jump to hooks or the hub until the additive layers are paying off —
the ordering *is* the method.
