# Repository Guidelines

## Project Structure & Module Organization
This repo tracks macOS dotfiles that are symlinked into $HOME. Shell entrypoints (.zshrc, .zprofile, .zshenv, .profile, .bash_profile) live at the root with UI configs like .wezterm.lua and .p10k.zsh. Application folders under .config/ house editor/terminal state: nvim/ (NvChad Lua modules), zed/ (settings + keymaps JSON), and zellij/ (KDL layouts).

## Build, Test & Development Commands
- `nvim --headless "+Lazy sync" +qa` validates plugin specs in `.config/nvim/lua/plugins` after dependency edits.
- `zsh -n .zshrc && zsh -i -c exit` catches syntax issues, then launches an interactive prompt to confirm Powerlevel10k, fzf, and env hooks still load.
- `jq . .config/zed/settings.json` (and other JSON files) enforces strict formatting before committing.
- `rg --files` and `rg "<term>" -n` should be your default file/contents search to keep updates consistent across duplicated configs.

## Coding Style & Naming Conventions
Match the prevailing style: two-space indents for shell profiles, tabs in Lua (NvChad + WezTerm), pretty-printed JSON for Zed, and concise comments only when behavior is non-obvious. Keep environment names upper snake case (`NVM_DIR`), aliases lowercase (`fvim`, `lzd`), and new scripts executable with dashed names (`bin/docker-start`). Use `stylua` and `shfmt -i 2 -ci` before large refactors; commit the formatted result.

## Testing & Validation Guidelines
Run `shellcheck <file>` on shell updates, then reopen a new terminal session to observe prompts, aliases, and PATH changes. For Neovim, open `nvim` and execute `:checkhealth` plus any relevant language tools (Mason, Treesitter) whenever plugin lists or LSP configs change. Reload WezTerm/Zellij after editing their configs and describe any manual steps in the PR body.

## Commit & Pull Request Guidelines
The history follows Conventional Commits with scopes (`feat(zed): …`, `fix(nvim): …`); keep subjects imperative and under ~70 characters. Group related config edits together so stow/restore cycles remain atomic, and avoid mixing shell + editor changes unless they depend on each other. PRs should call out the files touched, the validation commands you ran, and screenshots for visual tweaks (themes, prompts, terminal palettes).

## Security & Configuration Tips
Do not commit secrets or machine-specific tokens; keep them in ignored `.local` files or the macOS keychain. When a change adds a dependency (Homebrew formula, npm tool, etc.), guard it with `command -v` checks and mention install steps in the PR description so other machines can reproduce the setup.
