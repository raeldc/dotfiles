---
id: 0024-add-mise
kind: deterministic
platform: global
run: command -v mise >/dev/null 2>&1 && mise --version
---
# Add mise

Mise is managed by `manifests/homebrew.json` on macOS and Linux. The manifest
installs it during bootstrap/sync; this activity verifies that the command is
available and does not install a package.

The existing `.zshenv` appends mise's shims to PATH without shadowing tools
provided by Homebrew, proto, or nvm. No global mise config is required;
project-specific tool versions belong in their projects, while downloaded
tools and caches remain machine-local.
