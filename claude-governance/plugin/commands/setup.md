---
name: setup
description: Bootstrap a developer's workspace — enable the governance plugin, render tool-server config, install servers.
effort: high
allowed-tools: >
  Bash
  Read
  Write
---

# /setup — Bootstrap the Workspace

Run once after cloning the repos. Configures everything the assistant needs locally. There is no
"link capabilities into a hub" step anymore — shared capability is delivered by this plugin, and each
repo declares its own facts in its `repo-manifest.json`.

## Procedure

1. **Detect the developer's username** (`whoami`) → `$DEVELOPER`.

2. **Enable the governance plugin** from the team marketplace, so the shared skills, agents, hooks, and
   rules are present in every session. Updates arrive by upgrading the plugin version — nothing is
   copied per-repo.

3. **Render the tool-server config** from the committed template, substituting the username:
   ```bash
   sed "s/DEVELOPER/$DEVELOPER/g" .mcp.json.template > .mcp.json
   ```
   `.mcp.json` is gitignored — it holds machine-specific paths and is never committed.

4. **Install each tool server** into its own local virtual environment.

5. **Confirm the estate map is reachable** (the `claude-governance` repo is cloned), since the
   launch-point session reads it to assemble per-project working sets.

6. **Report** a status table and remind the developer to launch work from the `projects` repo and
   restart the assistant so the plugin and tool servers load.
