#!/bin/bash
# SessionStart hook for the projects (launch-point) repo.
# Three jobs: pull the latest shared governance, load the estate map, and report repo state.
# Non-blocking — always exits 0.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"   # the workspace holding all repos side by side
ESTATE_MAP="$WS_ROOT/claude-governance/estate/estate-map.json"

CONTEXT=""
WARNINGS=""

# 1. Pull latest governance so the newest shared skills/rules + estate map are present this session.
if [ -d "$WS_ROOT/claude-governance/.git" ]; then
  git -C "$WS_ROOT/claude-governance" pull --quiet --ff-only 2>/dev/null || \
    WARNINGS="${WARNINGS:+${WARNINGS}\n}Could not fast-forward claude-governance — pull manually."
fi

# 2. Surface the estate map so the assistant can assemble a working set from intent.
if [ -f "$ESTATE_MAP" ]; then
  CONTEXT="Estate map available at: ${ESTATE_MAP}. Read it to find which repos a task touches and how each deploys."
else
  WARNINGS="${WARNINGS:+${WARNINGS}\n}Estate map not found — is the claude-governance repo cloned?"
fi

# 3. Report the state of any product repos that are checked out.
for path in "$WS_ROOT"/product*/; do
  [ -d "${path}.git" ] || continue
  name="$(basename "$path")"
  branch=$(git -C "$path" branch --show-current 2>/dev/null || echo unknown)
  dirty=$(git -C "$path" status --porcelain 2>/dev/null | head -1)
  if [ -n "$dirty" ]; then
    CONTEXT="${CONTEXT:+${CONTEXT}\n}${name}: uncommitted changes (${branch})"
  fi
done

OUTPUT="{}"
if [ -n "$CONTEXT" ]; then
  OUTPUT=$(echo "$OUTPUT" | jq --arg c "$(printf '%b' "$CONTEXT")" '.hookSpecificOutput.hookEventName="SessionStart" | .hookSpecificOutput.additionalContext=$c')
fi
if [ -n "$WARNINGS" ]; then
  OUTPUT=$(echo "$OUTPUT" | jq --arg w "$(printf '%b' "$WARNINGS")" '.systemMessage=$w')
fi
echo "$OUTPUT"
exit 0
