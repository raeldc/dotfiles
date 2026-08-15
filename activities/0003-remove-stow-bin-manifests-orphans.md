---
id: 0003-remove-stow-bin-manifests-orphans
kind: deterministic
platform: global
run: for e in "$HOME/bin"/*; do [ -L "$e" ] || continue; case "$(readlink "$e")" in */.dotfiles/bin/*) rm -f "$e";; esac; done 2>/dev/null; for e in "$HOME/manifests"/*; do [ -L "$e" ] || continue; case "$(readlink "$e")" in */.dotfiles/manifests/*) rm -f "$e";; esac; done 2>/dev/null; rmdir "$HOME/bin" "$HOME/manifests" 2>/dev/null || true
---
# Remove orphaned ~/bin and ~/manifests stow symlinks

`bin/` and `manifests/` are now in `.stow-local-ignore`, so stow no longer
manages them. Machines stowed before that change still have `~/bin/*` and
`~/manifests/*` symlinks pointing into `~/.dotfiles`; `stow --restow` won't
remove them because it no longer owns them.

This removes only symlinks that point into `~/.dotfiles/bin` / `.dotfiles/manifests`
(real files and foreign symlinks are left untouched) and rmdir's the dirs when
empty. Idempotent: a no-op once the orphans are gone. The repo's `bin/` stays
on PATH via `~/.dotfiles/bin`.
