#!/bin/bash
# Stop hook: warn about uncommitted work across all repos at session end, so the
# delivery flow doesn't silently leave changes behind.
set -euo pipefail

# This hook ships in a plugin installed OUTSIDE the workspace, so it cannot locate repos
# relative to its own path. The workspace is the parent of the launch-point (projects) repo,
# which the harness exposes as CLAUDE_PROJECT_DIR.
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
WS_ROOT="$(cd "$PROJECT_DIR/.." && pwd)"

DIRTY=""
for path in "$WS_ROOT"/*/; do
  [ -d "${path}.git" ] || continue
  name="$(basename "$path")"
  if [ -n "$(git -C "$path" status --porcelain 2>/dev/null | head -1)" ]; then
    DIRTY="${DIRTY:+${DIRTY}, }${name}"
  fi
done

if [ -n "$DIRTY" ]; then
  echo "{\"systemMessage\":\"Uncommitted changes in: ${DIRTY}. Use /ship to deliver before ending.\"}"
fi
exit 0
