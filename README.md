# Dotfiles Overview

This repository mirrors the macOS `$HOME` layout and is stowed into place on a new machine. Use it to recreate shell profiles, editor configs, and helper scripts across systems.

## Reconfiguring Neovim
All Neovim settings live in `.config/nvim`, built on NvChad with `lazy.nvim` for plugin management. To bring the same setup to a new Mac:

1. **Clone & link** – Clone this repo and symlink/stow `.config/nvim` into `~/.config/nvim`.
2. **Install dependencies** – Ensure `neovim`, `git`, and everything in `HOME_BREW_PACKAGES.md` are installed (NvChad plugins depend on ripgrep, node, etc.).
3. **First launch** – Open Neovim once; `init.lua` will bootstrap `lazy.nvim`, pull NvChad v2.5, and install the plugin sets defined under `lua/plugins`.
4. **Custom modules** – Repo-local overrides live in:
   - `lua/options.lua` and `lua/mappings.lua` for editor defaults and keymaps.
   - `lua/configs/*` and `lua/plugins/*` for plugin-specific settings (LSP, formatter, IDE features, etc.).
   - `lua/toggle_linenumber.lua` for the line-number toggle helper sourced in `init.lua`.
5. **Cached theme** – NvChad’s Base46 cache is expected under `stdpath('data')/nvchad/base46/`; the first Neovim run regenerates cached theme/statusline files automatically.
6. **Updates** – Reopen Neovim or run `:Lazy sync` whenever you change plugin specs inside `lua/plugins`.

Refer to `AGENT_ACTIONS.md` for a running log of machine bootstrap steps and `HOME_BREW_PACKAGES.md` for the full Homebrew package list to reinstall.

