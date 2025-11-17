# Repository Guidelines

## Project Structure & Module Organization
Dotfiles mirror macOS $HOME via symlinks. Root-level shell entrypoints (.zshrc, .zprofile, .zshenv, .profile, .bash_profile) sit beside UI configs like .wezterm.lua and .p10k.zsh. Editor and terminal assets live under .config/: nvim/ (NvChad Lua modules inside lua/), zed/ (settings.json, keymap.json, themes/), and zellij/ (KDL layouts). CLI helpers belong in bin/ (e.g., bin/goland); keep scripts single-purpose and document new binaries here or in CLAUDE.md.

## Build, Test & Development Commands
- `nvim --headless "+Lazy sync" +qa` verifies plugin specs in `.config/nvim/lua/plugins` after dependency tweaks.
- `zsh -n .zshrc && zsh -i -c exit` syntax-checks the profile, then ensures Powerlevel10k, fzf, and path exports still load in an interactive shell.
- `jq . .config/zed/settings.json` (repeat for other JSON) enforces formatting for Zed artifacts.
- `rg "<term>" -n` / `rg --files` should be your default search across duplicated configs; skip slower `find`+`grep` chains.

## Coding Style & Naming Conventions
Use two-space indents in shell blocks, tabs in Lua (NvChad + WezTerm defaults), and prettified JSON with trailing newlines for Zed. Keep environment variables uppercase snake_case (`NVM_DIR`), aliases lowercase (`fvim`, `docker-start`), and script names dashed (`bin/colima-start`). Guard optional tooling with `command -v` checks and add comments only when behavior is non-obvious.

## Testing & Validation Guidelines
Shell edits: run `shellcheck <file>` plus a fresh terminal session to verify prompts and PATH changes. Neovim tweaks: open `nvim`, run `:checkhealth`, and note Mason/Treesitter status if you touched LSP or plugins. For terminal configs (WezTerm, Zellij), restart the app/session and capture regressions or screenshots whenever keymaps or palettes move. Document any manual migration (e.g., `stow` commands) in AGENTS.md for future passes.

## Commit & Pull Request Guidelines
Commits follow Conventional Commits with scopes (`feat(zed): …`, `chore(shell): …`); keep subjects imperative and under ~70 chars. Group related config files so symlink updates stay atomic and avoid mixing shell + editor tweaks unless dependent. PRs should list touched paths, verification commands, screenshots for visual tweaks, and mention new dependencies (Homebrew, npm, Cargo) with install notes.

## Security & Configuration Tips
Keep secrets or machine-specific tokens out of Git; use ignored `.local` files or the macOS keychain. Wrap new tooling in guards (`command -v uv >/dev/null || return`) so clean machines do not fail during login, and record any extra bootstrap steps in this guide.

## Activity Tracking
- Record every command and manual step in `AGENT_ACTIONS.md` so the workflow can be replayed on a fresh machine.
