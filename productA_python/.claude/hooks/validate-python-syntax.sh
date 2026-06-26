#!/bin/bash
# PostToolUse hook: byte-compile a just-edited Python file to catch syntax errors immediately.
set -euo pipefail

INPUT="$(cat)"
FILE="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"
case "$FILE" in
  *.py)
    if ! python -m py_compile "$FILE" 2>/tmp/pycompile.err; then
      echo "{\"systemMessage\":\"Syntax error in $FILE: $(head -1 /tmp/pycompile.err)\"}"
    fi
    ;;
esac
exit 0
