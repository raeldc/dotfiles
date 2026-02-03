# Dotfiles Setup Guide

This repo mirrors the macOS `$HOME` layout and is symlinked into place on a new machine. Follow the steps below to recreate the full shell/editor environment.

## 1. System prerequisites
1. Install Xcode Command Line Tools (required by Homebrew):
   ```sh
   xcode-select --install
   ```
2. Install Homebrew if missing:
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Ensure Homebrew is on PATH:
   ```sh
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

## 2. Clone the repo
```sh
git clone git@rael.github.com:raeldc/dotfiles.git ~/.dotfiles
```

## 3. Install packages
Install all formulae and casks listed in `HOME_BREW_PACKAGES.md`:
```sh
cd ~/.dotfiles
grep -A999 '^## Formulae' HOME_BREW_PACKAGES.md \
  | sed -n '2,/^## Casks/p' \
  | grep -oP '(?<=^- )\S+' \
  | xargs brew install

grep -A999 '^## Casks' HOME_BREW_PACKAGES.md \
  | grep -oP '(?<=^- )\S+' \
  | xargs brew install --cask
```

Notes from past setup history:
- `brew install rust`
- `brew install bitwarden`
- `brew install --cask wezterm`
- `brew install --cask raycast`

## 4. Link dotfiles into $HOME
This repo mirrors `$HOME`, so link each file or stow the repo into place.

Manual symlinks:
```sh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.zprofile ~/.zprofile
ln -s ~/.dotfiles/.profile ~/.profile
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/.wezterm.lua ~/.wezterm.lua
ln -s ~/.dotfiles/.config ~/.config
```

If you prefer stow, install it first (`brew install stow`) and use your preferred stow layout.

## 5. Local-only scripts and secrets
Some shell files source local machine scripts. Create these as needed and keep secrets out of Git.

Create `~/.local/bin/env`:
```sh
mkdir -p ~/.local/bin
cat <<'EOF' > ~/.local/bin/env
#!/usr/bin/env sh
# Add per-machine PATH overrides or exports here.
EOF
chmod +x ~/.local/bin/env
```

If you use Rust via rustup, ensure `~/.cargo/env` exists:
```sh
curl https://sh.rustup.rs -sSf | sh
```

## 6. Shell dependencies from `.zshrc`
Install or configure the tools referenced by `.zshrc`:
- NVM: install and ensure `~/.nvm/nvm.sh` exists (this drives Node versions).
- FZF + Bat: `fzf` for shell integration and `bat` for previews.
- Powerlevel10k: `powerlevel10k` theme + `~/.p10k.zsh` config.
- Zsh plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`.
- CLI tools: `eza`, `zoxide`, `terraform`, `colima`, `cloudflared`.
- pnpm: make sure the configured `PNPM_HOME` and PATH are valid.

## 7. Editor and terminal setup
Neovim (NvChad v2.5):
1. Open Neovim once to bootstrap lazy.nvim.
2. Or run:
   ```sh
   nvim --headless "+Lazy sync" +qa
   ```

Zed and Zellij configurations live in `.config/zed` and `.config/zellij`.

## 8. Verify shell config
```sh
zsh -n ~/.zshrc && zsh -i -c exit
```

## 9. Ongoing updates
- Neovim plugin changes: reopen Neovim or run `:Lazy sync`.
- Zed JSON: format with `jq . .config/zed/settings.json`.
- Keep `AGENT_ACTIONS.md` updated with new bootstrap commands.
