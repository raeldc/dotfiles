# Agent Onboarding Guide

This is the canonical agent guide for this repo. Follow it as the source of truth.

## Repository Map
Dotfiles mirror `$HOME` via symlinks. Root shell entrypoints live at the repo root; app configs live in `.config/`.
- Shell: `.zshrc`, `.zprofile`, `.zshenv`, `.profile`, `.bash_profile`
- Terminal/UI: `.wezterm.lua`, `.p10k.zsh`
- Editor/terminal configs: `.config/nvim/`, `.config/zed/`, `.config/zellij/`, `.config/alacritty/`, `.config/ghostty/`
- Helper scripts: `bin/` (single-purpose scripts, kebab-case)

## Config Quick Map
Use this to jump straight to the right file for common instructions.
- Shell startup: `.zshrc`, `.zprofile`, `.zshenv`, `.profile`, `.bash_profile`
- Shell prompt/theme: `.p10k.zsh`
- WezTerm: `.wezterm.lua`
- Zellij: `.config/zellij/`
- Neovim: `.config/nvim/`
- Zed: `.config/zed/`
- Alacritty: `.config/alacritty/`
- Ghostty: `.config/ghostty/`
- OpenCode: `.config/opencode/`
- Cursor: `cursor/Library/Application Support/Cursor/User/`
- JetBrains GoLand: `jetbrains/Library/Application Support/JetBrains/GoLand2025.2/`
- Antigravity: `antigravity/`
- Gemini: `.gemini/`
- Kilocode: `.kilocode/`
- Helper scripts: `bin/`
- Local-only env: `~/.local/bin/env`

## OS-Specific Bootstrap
Homebrew is the preferred package manager on both macOS and Linux.

### macOS
1. Install Xcode CLT: `xcode-select --install`
2. Install Homebrew (if missing):
   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Ensure Homebrew on PATH: `eval "$(/opt/homebrew/bin/brew shellenv)"`
4. Install packages from `manifests/homebrew.json` (see Install Commands below)
5. Link dotfiles into `$HOME` using GNU Stow (see Linking Dotfiles)

### Linux
1. Install Homebrew (Linuxbrew) first:
   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Ensure Homebrew on PATH (Linuxbrew install output provides the eval line)
3. Install packages from `manifests/homebrew.json` (formulae only; skip casks)
4. Link dotfiles into `$HOME` using GNU Stow (see Linking Dotfiles)
5. If a dependency is missing for Homebrew itself, use the system package manager only to satisfy that prerequisite, then revert to Homebrew

## Package Manifest
The package source of truth is `manifests/homebrew.json`. Do not edit generated lists in other files.
When installing software, prefer Homebrew first, then update `manifests/homebrew.json` to match the change.

Install commands (macOS):
```sh
bin/brew-install --taps
bin/brew-install --formulae
bin/brew-install --casks
```

Install commands (Linux):
```sh
bin/brew-install --taps
bin/brew-install --formulae
```

## Linking Dotfiles
Use GNU Stow for all dotfile linking.
```sh
stow --dir="$HOME/.dotfiles" --target="$HOME" .
```

## Local-Only Files
Keep secrets and machine-specific config out of Git. Use `~/.local/bin/env` for per-machine exports.
See `docs/local/README.md` for the contract and examples.

## Verification Matrix
Run the checks that match your changes:
- Shell files: `shellcheck <file>` and `zsh -n .zshrc && zsh -i -c exit`
- Neovim plugins: `nvim --headless "+Lazy sync" +qa`
- Zed JSON: `jq . .config/zed/settings.json`
- WezTerm/Zellij: restart the app/session and confirm keymaps + colors

## Coding Conventions
- Shell: 2-space indent
- Lua (Neovim/WezTerm): tabs
- JSON: formatted with trailing newline
- Env vars: `UPPERCASE_SNAKE_CASE`
- Aliases: lowercase
- Scripts: kebab-case and single-purpose
- Guard optional tooling with `command -v <tool> >/dev/null || return`

## Commit Style
Conventional Commits with scopes, e.g. `chore(shell): update zshrc`. Keep subjects imperative and <70 chars.
