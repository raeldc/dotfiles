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
- Removed `bd sync` from the landing-the-plane workflow in `AGENTS.md`.

### Commands Executed
- `ls -la`
- `ls -la .config`
- `git status -sb`
- `git remote -v`
- `git log -5 --oneline`

### Bootstrap Run (README)

#### Commands Executed
- `xcode-select -p`
- `command -v brew`
- `eval "$(/opt/homebrew/bin/brew shellenv)"`
- `python - <<'PY' ... PY` (attempted tap parse, python missing)
- `python3 - <<'PY' ... PY` (extracted taps from `HOME_BREW_PACKAGES.md`)
- `python3 - <<'PY' ... PY | xargs -n1 brew tap` (failed pipe attempt)
- `python3 - <<'PY' ... PY | xargs -n1 brew tap` (failed pipe attempt)
- `python3 - <<'PY' ... PY` (tap install loop)
- `python3 - <<'PY' ... PY` (brew install formulae, timed out)
- `python3 - <<'PY' ... PY` (brew install formulae retry, timed out)
- `python3 - <<'PY' ... PY` (brew install casks, timed out)
- `ls "/Users/rael"`
- `ls "/Users/rael/.local"`
- `mkdir -p "/Users/rael/.local/bin"`
- `chmod +x "/Users/rael/.local/bin/env"`
- `stow --dir="/Users/rael/.dotfiles" --target="/Users/rael" .`
- `nvim --headless "+Lazy sync" +qa`
- `zsh -n "/Users/rael/.zshrc" && zsh -i -c exit`
- `python3 - <<'PY' ... PY` (brew install formulae, completed)
- `python3 - <<'PY' ... PY` (brew install casks, checksum mismatch)
- `ls "/Users/rael/Library/Caches/Homebrew/downloads"`
- `rm "/Users/rael/Library/Caches/Homebrew/downloads/2c0358f5be69634ddad63bdcea7e11c51211301e6cbb16d5d422df0e72476a80--flutter_macos_arm64_3.38.9-stable.zip"`
- `brew install --cask flutter`
- `brew install rust`
- `brew install --cask bitwarden font-symbols-only-nerd-font macfuse podman-desktop warp wezterm`
- `brew install --cask bitwarden podman-desktop warp wezterm`

#### Manual Changes
- Created `~/.local/bin/env` and made it executable.
- Linked dotfiles into `$HOME` using GNU Stow.

#### Notes
- `brew install --cask flutter` hit a checksum mismatch, then timed out on re-download.
- `brew install --cask macfuse` failed because sudo requires an interactive terminal.
- `zsh -n ~/.zshrc && zsh -i -c exit` returned `can't change option: zle`.

## 2026-02-04

### Rust Toolchain Install

#### Commands Executed
- `command -v rustup`
- `command -v cargo`
- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`

#### Manual Changes
- Installed rustup-managed Rust toolchain and cargo in `~/.cargo`.

### Zellij Install

#### Commands Executed
- `brew install zellij`

### Alacritty Font Size

#### Commands Executed
- `ls`
- `ls ".config"`
- `stow --dir="/Users/rael/.dotfiles" --target="/Users/rael" .`

#### Manual Changes
- Added `~/.config/alacritty/alacritty.toml` with a larger font size.

### Ghostty Config

#### Commands Executed
- `stow --dir="/Users/rael/.dotfiles" --target="/Users/rael" .`

#### Manual Changes
- Added `~/.config/ghostty/config` aligned with WezTerm colors, font, and opacity.

### Ghostty Option/Alt

#### Commands Executed
- `stow --dir="/Users/rael/.dotfiles" --target="/Users/rael" .`

#### Manual Changes
- Set `macos-option-as-alt = true` in `~/.config/ghostty/config`.

### Stow Ignore

#### Manual Changes
- Added `.stow-local-ignore` to skip `*.md` files and docs directories.

### SSH Key Move

#### Commands Executed
- `ls "/Users/rael/.ssh"`
- `mv "rael.devbox" "/Users/rael/.ssh/rael.devbox" && mv "rael.devbox.pub" "/Users/rael/.ssh/rael.devbox.pub"`

### Git Identity Update

#### Commands Executed
- `git config user.name "rael" && git config user.email "rael@lear.one" && git config --global user.name "rael" && git config --global user.email "rael@psmnd.dev"`

### Re-author Recent Commits

#### Commands Executed
- `git rebase --rebase-merges --exec "git commit --amend --no-edit --author='rael <rael@lear.one>'" HEAD~3`
- `git rebase --rebase-merges --autostash --exec "git commit --amend --no-edit --author='rael <rael@lear.one>'" HEAD~3`

### Agent Onboarding Reorg

#### Commands Executed
- `ls`
- `ls -a`
- `ls ".config"`
- `chmod +x "/Users/rael/.dotfiles/bin/brew-install"`

#### Manual Changes
- Rewrote `AGENTS.md` as the canonical onboarding guide and removed redundant sections.
- Added `manifests/homebrew.json` as the machine-readable package manifest.
- Added `bin/brew-install` helper for manifest-driven Homebrew installs.
- Added setup docs under `docs/setup/` and local-only contract at `docs/local/README.md`.
- Updated `README.md` to point to the new guides and manifest.
- Deleted `CLAUDE.md`, `WARP.md`, and `HOME_BREW_PACKAGES.md`.
