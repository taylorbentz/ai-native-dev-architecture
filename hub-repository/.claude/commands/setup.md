---
name: setup
description: Bootstrap a developer's workspace — render tool-server config, install servers, link capabilities.
effort: high
allowed-tools: >
  Bash
  Read
  Write
---

# /setup — Bootstrap the Workspace

Run once after cloning the repos. Configures everything the assistant needs locally.

## Procedure

1. **Detect the developer's username** (`whoami`) → `$DEVELOPER`.

2. **Render the tool-server config** from the committed template, substituting the username:
   ```bash
   sed "s/DEVELOPER/$DEVELOPER/g" .mcp.json.template > .mcp.json
   ```
   `.mcp.json` is gitignored — it holds machine-specific paths and is never committed.

3. **Install each tool server** into its own local virtual environment.

4. **Link product-repo capabilities up into the hub**, tagged by provenance prefix so ownership stays
   legible. Links are local artifacts, excluded from the hub's committed tree:
   ```bash
   HUB=".claude/commands"
   ln -sf "<WORKSPACE>/productA_python/.claude/commands/etl-validate.md"   "$HUB/pa-etl-validate.md"
   ln -sf "<WORKSPACE>/productB_api/.claude/commands/api-contract-check.md" "$HUB/pb-api-contract-check.md"
   # ...one per contributed capability
   ```

5. **Report** a status table and remind the developer to restart the assistant so the tool servers load.

## Convention

Composed capabilities use a `pa-` (ProductA) or `pb-` (ProductB) prefix. Hub-native skills have no
prefix. This makes provenance obvious at a glance in the skill list.
