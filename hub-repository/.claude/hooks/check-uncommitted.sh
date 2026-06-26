#!/bin/bash
# Stop hook: warn about uncommitted work across all repos at session end, so the
# delivery flow doesn't silently leave changes behind.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

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
