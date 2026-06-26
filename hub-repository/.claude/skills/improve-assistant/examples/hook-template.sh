#!/bin/bash
# Example hook. Reads the harness event JSON on stdin, decides whether to allow or block.
# Test in isolation before wiring into settings.json.
set -euo pipefail

INPUT="$(cat)"

# Example: extract a field with jq and gate on it.
# tool="$(echo "$INPUT" | jq -r '.tool_name // empty')"
# if [ "$tool" = "SomethingRisky" ]; then
#   echo '{"decision":"block","reason":"Explain why."}'
#   exit 0
# fi

# Default: allow.
exit 0
