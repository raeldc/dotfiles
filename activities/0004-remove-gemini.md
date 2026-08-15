---
id: 0004-remove-gemini
kind: deterministic
platform: global
run: if command -v brew >/dev/null 2>&1 && brew list gemini-cli >/dev/null 2>&1; then brew uninstall gemini-cli; fi; find "$HOME/.gemini" -type l 2>/dev/null | while IFS= read -r e; do case "$(readlink "$e")" in */.dotfiles/.gemini/*) [ -e "$e" ] || rm -f "$e";; esac; done; find "$HOME/.gemini" -depth -type d -empty -delete 2>/dev/null; true
---
# Remove the Gemini CLI and its stowed config

Gemini was dropped from the setup: `gemini-cli` is gone from the Homebrew
manifest and `.gemini/` is no longer in the repo. This uninstalls the brew
formula where present and removes the now-dangling `~/.gemini` symlinks (at any
depth) that pointed into `~/.dotfiles/.gemini` — real, non-symlink files under
`~/.gemini` are left alone — then deletes any directories left empty.

Idempotent: a no-op once gemini-cli is uninstalled and the links are gone.
Local Gemini credentials (oauth_creds.json, etc.) were never committed.
