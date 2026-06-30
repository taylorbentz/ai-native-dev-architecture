#!/bin/bash
# validate-estate-map.sh — flag drift between the estate map and each repo's repo-manifest.json.
#
# The estate map (estate-map.json) is the assembled view; each repo declares its own facts in its
# repo-manifest.json. Those two must agree. This check catches the one consistency risk the
# aggregation model introduces: a repo changes its manifest and the map is not updated to match
# (or vice versa).
#
# Run it locally before committing a manifest change, and in the governance repo's CI.
#
# Exit 0 = everything agrees. Exit 1 = drift found (details printed).
#
# In this illustration all repos sit side by side under one root, so the workspace is two levels up
# from this script. In real life the repos are separate; point WORKSPACE_ROOT at wherever they are
# checked out (e.g. in CI).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAP="$SCRIPT_DIR/estate-map.json"
WS_ROOT="${WORKSPACE_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

# The fields a manifest and a map row share (manifest's "verify" is intentionally repo-only).
# Arrays are sorted so element order never causes a false positive.
PROJ='{name, capability, stack, branch_model, main_push_deploys_to, depends_on: (.depends_on // [] | sort), provides_to: (.provides_to // [] | sort)}'

drift=0
map_names="$(jq -r '.repos[].name' "$MAP")"

# 1. Every repo in the map must have a matching, agreeing manifest.
while IFS= read -r name; do
  [ -n "$name" ] || continue
  manifest="$WS_ROOT/$name/repo-manifest.json"
  if [ ! -f "$manifest" ]; then
    echo "MISSING: '$name' is in the estate map but has no repo-manifest.json at $name/"
    drift=1
    continue
  fi
  row="$(jq -S --arg n "$name" ".repos[] | select(.name==\$n) | $PROJ" "$MAP")"
  man="$(jq -S "$PROJ" "$manifest")"
  if [ "$row" != "$man" ]; then
    echo "DRIFT: '$name' — estate map row and repo-manifest.json disagree (< map | > manifest):"
    diff <(echo "$row") <(echo "$man") || true
    drift=1
  fi
done <<< "$map_names"

# 2. Every manifest in the workspace must have a row in the map (no orphans).
for manifest in "$WS_ROOT"/*/repo-manifest.json; do
  [ -e "$manifest" ] || continue
  mname="$(jq -r '.name' "$manifest")"
  if ! grep -qxF "$mname" <<< "$map_names"; then
    echo "ORPHAN: '$mname' has a repo-manifest.json but no row in the estate map"
    drift=1
  fi
done

if [ "$drift" -eq 0 ]; then
  echo "OK: estate map and all repo manifests agree."
fi
exit "$drift"
