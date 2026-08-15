---
id: 0007-migrate-claude-code-to-npm
kind: deterministic
platform: mac
run: if command -v brew >/dev/null 2>&1 && brew list --cask claude-code >/dev/null 2>&1; then brew uninstall --cask claude-code && brew cleanup claude-code; fi
---
# Migrate Claude Code off the Homebrew cask (npm now owns it)

Claude Code is now installed via npm (`@anthropic-ai/claude-code` in
`manifests/npm.json`, applied by `bin/npm-install`). The npm/native build
auto-updates itself; the Homebrew cask does not and lagged upstream, which is
why we switched.

The cask was removed from `manifests/homebrew.json`, so greenfield machines
never install it. This activity handles the other half: machines that already
have the cask must have it uninstalled, since dropping it from the manifest does
not remove an already-installed package.

The `run:` command is guarded and idempotent: it uninstalls the cask only if
present, so it is a no-op on greenfield machines (cask never installed), on
Linux (no casks), and on any machine already migrated. `bin/npm-install`
installs the npm version independently, and the npm bin dir precedes
`/opt/homebrew/bin` on PATH, so `claude` resolves to the npm build.
