---
id: 0021-unstow-pi-settings
kind: deterministic
platform: global
run: if [ -L "$HOME/.pi/agent/settings.json" ]; then case "$(readlink "$HOME/.pi/agent/settings.json")" in *.dotfiles/.pi/agent/settings.json) if [ -f "$HOME/.pi/agent/settings.json" ]; then cp -L "$HOME/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json.tmp" && mv "$HOME/.pi/agent/settings.json.tmp" "$HOME/.pi/agent/settings.json"; else mkdir -p "$HOME/.pi/agent" && cp "$HOME/.dotfiles/.pi/agent/settings.default.json" "$HOME/.pi/agent/settings.json"; fi;; esac; fi; true
---
# Unstow pi agent settings

`settings.json` is no longer stowed: pi rewrites it in place on every
launch/upgrade (e.g. `lastChangelogVersion` bumps), which churned the repo
and fought Stow's symlinks. It is now machine-local; the repo keeps only
`.pi/agent/settings.default.json` as the seed template.

This activity converts any remaining Stow symlink into a real file,
preserving its live content. If the symlink dangles (repo file already
removed by pull), it seeds a fresh `settings.json` from the template.
Real files and symlinks pointing elsewhere are left untouched, so
re-running is a no-op.
