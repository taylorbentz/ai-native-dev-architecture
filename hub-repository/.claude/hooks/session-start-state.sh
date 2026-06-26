#!/bin/bash
# SessionStart hook: grounds the assistant in real workspace state.
# Reports each repo's branch + dirtiness, warns on weekends. Non-blocking.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

CONTEXT=""
WARNINGS=""

DOW=$(date +%u)
if [ "$DOW" -ge 5 ]; then
  WARNINGS="Today is $(date +%A). Avoid trunk pushes and production promotions."
fi

for pkg in \
  "hub-repository:trunk" \
  "productA_python:trunk" \
  "productA_terraform:dev" \
  "productB_api:trunk" \
  "productB_infra:dev" \
  "productB_frontend:trunk"; do

  IFS=':' read -r name expected <<< "$pkg"
  path="$WS_ROOT/$name"
  [ -d "$path/.git" ] || continue

  branch=$(git -C "$path" branch --show-current 2>/dev/null || echo unknown)
  dirty=$(git -C "$path" status --porcelain 2>/dev/null | head -1)

  if [ "$branch" != "$expected" ]; then
    WARNINGS="${WARNINGS:+${WARNINGS}\n}${name} on '${branch}' (expected '${expected}')"
  fi
  if [ -n "$dirty" ]; then
    CONTEXT="${CONTEXT:+${CONTEXT}\n}${name}: uncommitted changes (${branch})"
  else
    CONTEXT="${CONTEXT:+${CONTEXT}\n}${name}: clean (${branch})"
  fi
done

OUTPUT="{}"
if [ -n "$CONTEXT" ]; then
  CTX=$(printf "Workspace state:\n%b" "$CONTEXT")
  OUTPUT=$(echo "$OUTPUT" | jq --arg c "$CTX" '.hookSpecificOutput.hookEventName="SessionStart" | .hookSpecificOutput.additionalContext=$c')
fi
if [ -n "$WARNINGS" ]; then
  OUTPUT=$(echo "$OUTPUT" | jq --arg w "$(printf '%b' "$WARNINGS")" '.systemMessage=$w')
fi
echo "$OUTPUT"
exit 0
