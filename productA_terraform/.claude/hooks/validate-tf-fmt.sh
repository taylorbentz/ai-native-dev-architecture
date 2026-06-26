#!/bin/bash
# PostToolUse hook: check formatting of a just-edited .tf file. Warns, does not block.
set -euo pipefail

INPUT="$(cat)"
FILE="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"
case "$FILE" in
  *.tf)
    if command -v terraform >/dev/null 2>&1; then
      if ! terraform fmt -check "$FILE" >/dev/null 2>&1; then
        echo "{\"systemMessage\":\"Run 'terraform fmt' on $FILE before committing.\"}"
      fi
    fi
    ;;
esac
exit 0
