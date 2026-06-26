#!/bin/bash
# PostToolUse hook: remind to lint a just-edited component. Warns, does not block.
set -euo pipefail

INPUT="$(cat)"
FILE="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"
case "$FILE" in
  *.tsx|*.ts)
    echo "{\"systemMessage\":\"Run 'npm run lint' on $FILE before committing.\"}"
    ;;
esac
exit 0
