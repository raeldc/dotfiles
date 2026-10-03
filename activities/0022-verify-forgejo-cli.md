---
id: 0022-verify-forgejo-cli
kind: deterministic
platform: global
run: command -v fj >/dev/null 2>&1 && fj version
---
# Verify Forgejo CLI

Forgejo CLI is managed by the existing `forgejo-cli` entry in
`manifests/homebrew.json` under `formulae.global`, for macOS and Linux.
Homebrew installs it during bootstrap/sync; this activity only verifies
the resulting `fj` command and does not install packages.

Installed and verified version 0.6.0 on the originating macOS machine with
`brew install forgejo-cli`. Homebrew supplies shell completions, and the
existing zsh completion setup already includes its site-functions directory.
No additional shared configuration is needed for default usage.

Authentication tokens and instance preferences remain machine-local; do not
stow or commit the CLI's credential files. Authenticate separately on each
machine with `fj --host <hostname> auth login` for OAuth-supported instances,
or `fj --host <hostname> auth add-token` for an application token.
