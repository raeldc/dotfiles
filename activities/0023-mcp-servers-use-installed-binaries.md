---
id: 0023-mcp-servers-use-installed-binaries
kind: inferential
platform: global
---
# Run MCP servers from installed binaries, not `npx …@latest`

`npx pkg@latest` keeps an `npm exec` wrapper (~115M RSS) alive next to every
MCP server for the life of each Claude session, and re-resolves `@latest`
into `~/.npm/_npx` on each launch. With ~14 long-lived sessions that was 28
wrappers / 3.2G of RAM and a steadily refilling npm cache.

The servers (`@playwright/mcp`, `apidog-mcp-server`, `nx-mcp`) are now global
packages in `manifests/npm.json`, so `bin/npm-install` provides
`playwright-mcp`, `apidog-mcp-server` and `nx-mcp` on PATH. On this machine:

1. Back up and edit every Claude config — `~/.claude.json` and each BFFS
   account's `.claude.json` under its sessions dir. In each project's
   `mcpServers`, replace `command: "npx"` entries for these packages with the
   binary as `command`, dropping `-y` and the `pkg@latest` arg but keeping
   the rest (e.g. `--project-id=…`). Keep mode 600.
2. Add a user-scope `mcpServers.playwright`
   (`{"type":"stdio","command":"playwright-mcp","args":[]}`) to each of those
   files and set `enabledPlugins["playwright@claude-plugins-official"]` to
   `false` in `~/.claude/settings.json` — the plugin hardcodes `npx`.
3. New sessions pick it up; existing ones keep their wrappers until restarted.

Verify: in a new session `ps -eo args | grep -c 'npm exec'` stays 0.
