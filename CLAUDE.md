# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS, managing configuration files for development tools and shell environments. The repository uses Git for version control and is managed via symlinks to the home directory.

## Repository Structure

```
.dotfiles/
├── .config/              # Application configurations
│   ├── nvim/            # Neovim configuration (NvChad-based)
│   ├── zed/             # Zed editor settings
│   └── zellij/          # Zellij terminal multiplexer config
├── .zshrc               # Zsh shell configuration
├── .zprofile            # Zsh profile (sets up Homebrew)
├── .zshenv              # Zsh environment (Cargo)
├── .bash_profile        # Bash profile
├── .profile             # Generic profile
├── .wezterm.lua         # WezTerm terminal configuration
└── .p10k.zsh           # Powerlevel10k theme configuration
```

## Shell Environment Architecture

### Initialization Order

1. `.zshenv` - Loads Cargo environment first
2. `.zprofile` - Sources `.profile` (in sh emulation mode), then initializes Homebrew
3. `.zshrc` - Main shell configuration, loads:
   - Completions (compinit, bashcompinit)
   - Powerlevel10k instant prompt
   - NVM (Node Version Manager)
   - fzf with preview using bat
   - Powerlevel10k theme from Homebrew
   - zsh-autosuggestions and zsh-syntax-highlighting
   - eza (ls replacement)
   - zoxide (cd replacement)
   - Custom environment from `~/.local/bin/env`

### Path Management

The `~/.local/bin/env` script ensures `~/.local/bin` is prepended to PATH (contains uv, uvx, and posting tools). Additional paths are added in:
- `.profile`: Python and Cargo binaries
- `.zshrc`: pnpm, NVM, custom paths

### Key Aliases and Tools

- `ls` → `eza --color=always --icons=always --no-time --no-permissions --no-user`
- `cd` → `zoxide` (z-style directory jumping)
- `fvim` - Opens files selected via fzf with bat preview in nvim
- `lzd` → `lazydocker`
- `docker-start` → `colima start --mount-type 9p`

## Editor Configurations

### Neovim (NvChad v2.5)

Located in `.config/nvim/`, using lazy.nvim plugin manager.

**Architecture:**
- Based on NvChad framework (v2.5 branch)
- `init.lua`: Entry point, sets up lazy.nvim, loads plugins and theme
- `lua/configs/`: Configuration modules (LSP, conform, IDE setup)
- `lua/plugins/`: Plugin specifications
  - `init.lua`: Core plugins (conform.nvim for formatting)
  - `ide.lua`: IDE features (LSP, Mason, TreeSitter, DAP, Rust tooling)
- `lua/mappings.lua`: Custom keybindings
- `lua/options.lua`: Vim options
- Custom toggle line number functionality via `lua/toggle_linenumber.lua`

**Key Settings:**
- Leader key: Space
- Line numbers: absolute + relative
- Fold method: indent (disabled by default)
- Auto-formatting: Disabled by default (conform.nvim BufWritePre commented out)

**IDE Features:**
- LSP via nvim-lspconfig + Mason
- Rust support: rust.vim, rustaceanvim, rustfmt on save
- DAP (Debug Adapter Protocol): nvim-dap installed
- TreeSitter for syntax highlighting

### Zed Editor

Located in `.config/zed/settings.json`.

**Key Configuration:**
- Base keymap: VSCode
- Vim mode: Enabled with relative line numbers
- Theme: Base16 Ayu Dark
- Icon theme: JetBrains New UI Icons (Dark)
- Font sizes: UI 16, Buffer 14
- Format on save: Off (except Go which is "on")
- AI Agent: Claude Sonnet 4.5, docked right, default profile "write"
- SSH connection configured for "devbox" host (user: rael)

### WezTerm

Configuration in `.wezterm.lua`.

**Features:**
- Custom color scheme (dark blue background with custom ANSI colors)
- Font: DroidSansM Nerd Font Mono, size 14
- Tab bar: Disabled
- Window: 90% opacity with 8px blur on macOS
- Vim-style pane navigation: Alt+hjkl
- Tab navigation: Alt+[]
- Custom keybind: Shift+Enter sends special escape sequence

### Zellij

Terminal multiplexer config in `.config/zellij/config.kdl`.

**Key Bindings:**
- Ctrl+g: Lock mode
- Ctrl+p: Pane mode (vim-style navigation with hjkl)
- Ctrl+t: Tab mode
- Ctrl+n: Resize mode
- Ctrl+s: Scroll mode
- Ctrl+o: Session mode
- Ctrl+h: Move mode
- Ctrl+b: Tmux compatibility mode
- Alt+hjkl: Quick pane focus switching
- Alt+n: New pane
- Alt+[]: Swap layouts

**Plugins:**
- tab-bar, strider (file picker), compact-bar, session-manager

## Development Workflow

### Package Management

- **Homebrew**: Primary package manager (initialized in `.zprofile`)
- **Node.js**: Managed via NVM (loaded in `.zshrc`)
- **Python**: UV/UVX tools in `~/.local/bin`
- **Rust**: Managed via Cargo (loaded in `.zshenv`)
- **pnpm**: Available at `/Users/rael/Library/pnpm` and `/usr/local/opt/pnpm@8/bin`

### Common Tools

- Docker: Via Colima (use `docker-start` alias)
- Terraform: Auto-completion enabled
- fzf: Fuzzy finder with bat preview integration
- Git: Repository tracked, typical commits update editor configs or packages

## Making Changes

When modifying configurations:

1. **Shell files**: Changes to `.zshrc`, `.zprofile`, etc. require `source ~/.zshrc` or new shell
2. **Neovim**: Restart nvim or run `:Lazy sync` for plugin changes
3. **Git tracking**: Modified files shown in git status are typically config updates being tested
4. **Symlinks**: These files are typically symlinked to `~/.dotfiles/` from home directory

## Important Notes

- `.gitignore` excludes most Zed config but includes themes and JSON files
- nvim-dap directory contains bundled plugin (not submodule)
- Shell integration available for iTerm2 and Kiro terminal
- P10k theme customization: Run `p10k configure` or edit `.p10k.zsh`
