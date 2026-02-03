# Agent Activity Log

## 2025-11-17

### Installed/Configured Tools Noted in `.zshrc`
- `compinit` / `bashcompinit` (zsh completion bootstrapping)
- Powerlevel10k (instant prompt plus theme via `/opt/homebrew/share/powerlevel10k`)
- `nvm` (with `$NVM_DIR` setup and bash completion)
- `fzf` (shell integration and `fvim` helper using `bat` preview)
- `eza` (aliased as `ls` with icons and color)
- `zsh-autosuggestions` and `zsh-syntax-highlighting`
- `pnpm` (custom `PATH` via `$PNPM_HOME`)
- `colima` helper `docker-start` alias
- `zoxide` (initialized via `eval "$(zoxide init --cmd cd zsh)"`)
- `terraform` completion via `/opt/homebrew/bin/terraform`
- Custom environment loader at `~/.local/bin/env`

### Documentation
- Captured every Homebrew formula/cask and replay steps in `HOME_BREW_PACKAGES.md` so future agents can reinstall the macOS toolchain.

### Commands Executed
- `ls`
- `ls -a .config`
- `ls .config/zed`
- `sed -n '1,200p' .config/zed/keymap.json`
- `rg -n '"space' .config/zed/keymap.json`
- `sed -n '200,400p' .config/zed/keymap.json`
- `rg -n "SendKeystrokes" -n . -g"*.json"`
- `rg -n "SendKeystrokes" .`
- `sed -n '1,200p' AGENT_ACTIONS.md`
- `jq . .config/zed/keymap.json`

### Manual Changes
- Added insert-mode space passthrough binding in `.config/zed/keymap.json` to avoid leader wait states.

## 2026-01-11

### Cursor Vim Keybindings Fix

#### Problem
Insert mode escape sequences (jk, jj, kk, uu) were blocking normal typing in Cursor. When pressing `j`, it would wait indefinitely for the next key instead of timing out and inserting the character like Neovim/Zed.

#### Changes Made
1. **Enabled Neovim integration** in `cursor/Library/Application Support/Cursor/User/settings.json`:
   - Set `vim.enableNeovim: true`
   - Added `vim.neovimPath: "/opt/homebrew/bin/nvim"`
   - Adjusted `vim.timeout` to 200ms

2. **Removed duplicate keybindings** from `cursor/Library/Application Support/Cursor/User/keybindings.json`:
   - Removed VSCode-style `"key": "j k"` etc. escape bindings
   - These are now handled solely via `vim.insertModeKeyBindings` in settings.json
   - With Neovim backend, escape sequences work identically to Neovim

#### Commands Executed
- `which nvim` → `/opt/homebrew/bin/nvim`

#### Verification Steps
1. Restart Cursor to apply settings
2. Enter insert mode and test:
   - Type `jk` quickly → should escape to normal mode
   - Type `ui` normally → should insert "ui" without blocking
3. If issues persist, check `:checkhealth` in command palette

## 2026-02-03

### Homebrew Inventory Refresh

#### Commands Executed
- `brew list --formula`
- `brew list --cask`
- `brew list --formula --full-name`
- `brew list --cask --full-name`
- `brew info --cask copilot-cli@prerelease`
- `git status --short`
- `git diff`
- `git log -5 --oneline`
- `git add HOME_BREW_PACKAGES.md AGENT_ACTIONS.md`
- `git commit -m "chore(homebrew): refresh package inventory"`
- `git pull --rebase`
- `bd sync`
- `git push`
- `git status --short`

#### Manual Changes
- Updated `HOME_BREW_PACKAGES.md` to reflect current Homebrew formulae and casks.
- Added a taps section to capture non-core Homebrew sources.

### Documentation
- Expanded `README.md` with step-by-step bootstrap instructions, using `.zshrc` and shell history to enumerate required tools.

### Commands Executed
- `ls -la`
- `ls -la .config`
- `git status -sb`
- `git remote -v`
- `git log -5 --oneline`
