#!/bin/bash
# PostToolUse hook: when a route file changes, remind to keep the OpenAPI spec in sync. Warns only.
set -euo pipefail

INPUT="$(cat)"
FILE="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"
case "$FILE" in
  */src/routes/*.ts)
    echo "{\"systemMessage\":\"Route changed ($FILE) — update the OpenAPI spec and run /api-contract-check.\"}"
    ;;
esac
exit 0
