#!/bin/bash
# PreToolUse (Bash) hook: blocks repo-modifying git commands that don't target a
# directory with `git -C`. Prevents committing to the wrong repo when one session spans many.
set -euo pipefail

INPUT="$(cat)"
CMD="$(echo "$INPUT" | jq -r '.tool_input.command // empty')"

# Only care about mutating git verbs.
if echo "$CMD" | grep -Eq '\bgit\b.*\b(add|commit|push|reset|checkout|merge|rebase)\b'; then
  # Allow if the invocation targets a directory explicitly.
  if ! echo "$CMD" | grep -Eq '\bgit\s+-C\b'; then
    echo '{"decision":"block","reason":"Repo-modifying git command must target a directory with: git -C <repo> ..."}'
    exit 0
  fi
fi
exit 0
