# Workstation Setup (Shared)

This repo mirrors `$HOME` and is symlinked into place on a new machine.

## Quick path (recommended)
After the OS-specific prerequisites (see `macos.md` / `linux.md`), run everything at once:
```sh
bin/bootstrap
```
It installs brew packages, node + npm globals (from `manifests/npm.json`), bun, plannotator,
and stows the dotfiles with `--no-folding`.

## Clone
On a fresh machine the `rael.github.com` SSH alias does not exist yet — use the plain URL first:
```sh
git clone git@github.com:raeldc/dotfiles.git ~/.dotfiles
# or, before SSH keys exist:
git clone https://github.com/raeldc/dotfiles.git ~/.dotfiles
```
After SSH is set up (see `manual.md`), you can switch to the alias:
```sh
git -C ~/.dotfiles remote set-url origin git@rael.github.com:raeldc/dotfiles.git
```

## Link dotfiles
Preferred: GNU Stow. Use `--no-folding` so runtime dirs (e.g. `~/.pi/agent/sessions`)
stay real directories in `$HOME` instead of folding into repo symlinks.
```sh
stow --no-folding --dir="$HOME/.dotfiles" --target="$HOME" .
```

## Local-only environment
Create `~/.local/bin/env` for per-machine exports and secrets (never commit).
```sh
mkdir -p "$HOME/.local/bin"
cat <<'EOF' > "$HOME/.local/bin/env"
#!/usr/bin/env sh
# Add per-machine PATH overrides or exports here.
EOF
chmod +x "$HOME/.local/bin/env"
```
Optionally also `~/.dotfiles/.env` for repo-local secrets (gitignored, sourced automatically).

## Verification
- Shell: `zsh -n ~/.zshrc && zsh -i -c exit`
- Neovim: `nvim --headless "+Lazy sync" +qa`
- Zed JSON: `jq . .config/zed/settings.json`

## Staying in sync
After changes are committed and pushed from one machine, apply them here:
```sh
bin/sync
```
