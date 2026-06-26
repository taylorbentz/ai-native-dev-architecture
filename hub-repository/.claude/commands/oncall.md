---
name: oncall
description: Triage incoming alerts and tickets, diagnose, and resolve safe ephemeral issues.
effort: high
allowed-tools: >
  Read
  Bash(git -C *)
---

# /oncall — Triage Incoming Work

Scan the work queue, classify each item, and act only within safe bounds.

## Procedure

1. **Gather.** Pull open tickets and recent alerts via the read-only tool servers.
2. **Classify** each item:
   - `ephemeral` — transient/self-healing (e.g. a retryable timeout)
   - `known` — matches a documented runbook
   - `novel` — needs human judgment
3. **Act:**
   - `ephemeral`: note it, re-check once, close if recovered.
   - `known`: follow the runbook's read-only diagnostic steps, summarize findings.
   - `novel`: gather context and escalate — do **not** take mutating action.
4. **Report** a table: item, classification, action taken, follow-up needed.

## Boundary

This skill observes and diagnoses. It never deploys, deletes, or modifies production state. Anything
beyond read-only diagnosis is escalated to a human.
