# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

Personal macOS dotfiles repository managed via symlinks (typically using `stow`). Tracks shell configurations, editor setups (Neovim, Zed, WezTerm, Zellij), and helper scripts. Files are symlinked from this repo to `$HOME` to maintain a consistent development environment across machines.

## Essential Commands

### Verification & Testing
```bash
# Shell syntax check + interactive load test
zsh -n .zshrc && zsh -i -c exit

# Verify Neovim plugin configuration (after modifying lua/plugins/*)
nvim --headless "+Lazy sync" +qa

# Format JSON configs (Zed settings, etc.)
jq . .config/zed/settings.json

# Shellcheck individual shell files
shellcheck .zshrc
```

### Neovim Health Checks
```bash
# Full health diagnostics (LSP, Mason, Treesitter status)
nvim
# Then run: :checkhealth
```

### Search & Discovery
```bash
# Prefer ripgrep for content search (faster than grep)
rg "<term>" -n

# List all tracked files
rg --files
```

### Bootstrap on New Machine
See `HOME_BREW_PACKAGES.md` for full Homebrew package reinstall commands and dependency list.

## Architecture & Key Patterns

### Shell Environment Loading Order
1. `.zshenv` → Cargo environment
2. `.zprofile` → Sources `.profile` in sh emulation mode, then initializes Homebrew (`/opt/homebrew/bin/brew shellenv`)
3. `.zshrc` → Main config: completions, Powerlevel10k, NVM, fzf, eza, zoxide, custom env from `~/.local/bin/env`

**Key aliases:**
- `ls` → `eza --color=always --icons=always --no-time --no-permissions --no-user`
- `cd` → `zoxide` (smart directory jumping)
- `fvim` → Opens fzf-selected files with bat preview in nvim
- `docker-start` → `colima start --mount-type 9p`

### Neovim Architecture (NvChad v2.5 + lazy.nvim)
**Entry point:** `init.lua`
- Sets leader to Space, enables absolute + relative line numbers
- Bootstraps lazy.nvim if missing
- Loads NvChad v2.5 framework + custom plugins from `lua/plugins/`
- Theme cache: `stdpath('data')/nvchad/base46/`

**Module structure:**
- `lua/options.lua` / `lua/mappings.lua` → Core editor settings and keybinds
- `lua/plugins/init.lua` → conform.nvim (auto-formatting disabled by default; uncomment `event = 'BufWritePre'` to enable)
- `lua/plugins/ide.lua` → LSP (nvim-lspconfig, Mason, mason-lspconfig), Treesitter, DAP, Rust tooling (rust.vim, rustaceanvim with rustfmt autosave)
- `lua/configs/*` → Plugin-specific configurations (LSP, conform, IDE setup)
- `lua/toggle_linenumber.lua` → Custom line number toggle helper

**Notable settings:**
- Leader: Space
- Fold method: indent (disabled by default via `foldenable = false`)
- Arrow keys disabled in all modes (enforces hjkl navigation)
- Custom escape sequences: `jk`, `jj`, `kk`, `uu` in insert mode
- Vim-style pane navigation: `Alt+Shift+HJKL`
- Buffer cycling: `Alt+[` / `Alt+]`

### Editor & Terminal Configs
**Zed** (`.config/zed/`): VSCode keybinds, Vim mode enabled, Claude Sonnet 4.5 agent, Base16 Ayu Dark theme, format-on-save off except Go

**WezTerm** (`.wezterm.lua`): DroidSansM Nerd Font 14pt, 90% opacity + blur, Alt+hjkl pane nav, Alt+[] tab nav

**Zellij** (`.config/zellij/config.kdl`): Tmux-compatible keybinds, Ctrl+g/p/t/n/s/o/h/b modes, Alt+hjkl quick pane switching, plugins: tab-bar, strider, compact-bar, session-manager

### Helper Scripts
**bin/goland** → Opens GoLand IDE via `open -na "GoLand.app"`

## Coding Conventions

**Indentation:**
- Shell scripts: 2 spaces
- Lua (Neovim, WezTerm): tabs
- JSON (Zed): prettified with trailing newlines

**Naming:**
- Environment variables: `UPPERCASE_SNAKE_CASE` (e.g., `NVM_DIR`)
- Aliases: lowercase (e.g., `fvim`, `docker-start`)
- Scripts: kebab-case (e.g., `bin/colima-start`)

**Defensive scripting:**
- Guard optional tools with `command -v <tool> >/dev/null || return` to prevent login failures on incomplete setups
- Keep secrets in ignored `.local` files or macOS keychain—never commit them

## Commit Conventions

Follow Conventional Commits with scopes:
- `feat(zed): ...`
- `chore(shell): ...`
- `fix(nvim): ...`

Keep subjects imperative, <70 chars. Group related config changes atomically. Include `Co-Authored-By: Warp <agent@warp.dev>` in commit messages when working with Warp.

## Important Notes

- **Documentation:** `AGENTS.md` contains detailed project structure and testing guidelines; `AGENT_ACTIONS.md` logs bootstrap commands for replay; `HOME_BREW_PACKAGES.md` has full dependency manifest
- **Changes require reload:** Shell edits need `source ~/.zshrc` or new terminal; Neovim plugin changes need restart or `:Lazy sync`
- **Symlink workflow:** Files typically symlinked via `stow` from this repo to `$HOME`
- **Package managers:** Homebrew (primary), NVM (Node.js), Cargo (Rust), UV/UVX (Python in `~/.local/bin`), pnpm (custom PATH)
