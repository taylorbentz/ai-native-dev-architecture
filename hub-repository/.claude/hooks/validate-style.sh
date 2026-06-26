#!/bin/bash
# PostToolUse (Edit|Write) hook: lightweight style check on the file just written.
# Warns (does not block) so mistakes surface immediately instead of at build time.
set -euo pipefail

INPUT="$(cat)"
FILE="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"
[ -n "$FILE" ] || exit 0
[ -f "$FILE" ] || exit 0

case "$FILE" in
  *.py)
    # Flag tabs (this project uses spaces) and trailing whitespace.
    if grep -nP '\t' "$FILE" >/dev/null 2>&1; then
      echo "{\"systemMessage\":\"Style: $FILE contains tabs; use 4 spaces.\"}"
    fi
    ;;
  *.tf)
    # Remind to run formatter.
    echo "{\"systemMessage\":\"Reminder: run 'terraform fmt' on $FILE before committing.\"}"
    ;;
esac
exit 0
