# Workstation Setup (Shared)

This repo mirrors `$HOME` and is symlinked into place on a new machine.

## Clone
```sh
git clone git@rael.github.com:raeldc/dotfiles.git ~/.dotfiles
```

## Link dotfiles
Preferred: GNU Stow.
```sh
stow --dir="$HOME/.dotfiles" --target="$HOME" .
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

## Verification
- Shell: `zsh -n ~/.zshrc && zsh -i -c exit`
- Neovim: `nvim --headless "+Lazy sync" +qa`
- Zed JSON: `jq . .config/zed/settings.json`
