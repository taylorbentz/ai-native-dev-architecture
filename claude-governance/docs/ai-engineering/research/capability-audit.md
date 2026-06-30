# Research: Capability Utilization Audit

A worked example of auditing an AI-assistant setup against the tool's *full* feature surface, then
scoring adoption. Treating under-utilization as technical debt is what turns an ad-hoc setup into a
deliberate architecture.

## Method

1. Enumerate the harness's capability categories (settings, hooks, skills, rules, subagents, tool
   servers, automation).
2. For each, list what's available vs. what the team actually uses.
3. Score utilization. Anything low is a candidate for a rollout phase.

## Example scorecard

| Category | Available | Currently used | Utilization |
|---|---|---|---|
| Settings & permissions | allow / deny / role templates | allow-list only | 30% |
| Hooks | many event types + filters | 2 hooks | 20% |
| Skills | frontmatter, fork, scoped tools, templates | basic single-file | 40% |
| Rules | path-scoped, unconditional, composed-up | a couple global | 30% |
| Subagents | specialists, isolation | basic | 25% |
| Tool servers | several read-only + scoped | configured | 90% |
| Automation | scheduled / headless runs | none | 0% |

**Overall: ~35%.**

## Reading the result

A low score isn't failure — it's a backlog. Each row becomes a phase, ordered by risk: documentation
and rules first (additive, zero blast radius), permissions and hooks last (can block work if wrong),
each with an explicit rollback. The point of the audit is to make the *next* improvement obvious and
deliberate rather than accidental.
