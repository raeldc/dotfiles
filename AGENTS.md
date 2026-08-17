# Agent Onboarding Guide

This is the canonical agent guide for this repo. Follow it as the source of truth.

## About this Project

This project is the "dotfiles" repo where reusable config is stowed. "Stow" means GNU Stow, a
command-line tool for symlinking files — the common use case is symlinking config files from a
folder (usually `~/.dotfiles`) into `$HOME`. So when the operator says "stow the config of this
tool," use GNU Stow to manage that tool's config in this folder. And when the operator asks you to
check a config, look here first; only venture out if it isn't here.

## Repository Map
Dotfiles mirror `$HOME` via symlinks. Root shell entrypoints live at the repo root; app configs live in `.config/`.
- Shell: `.zshrc`, `.zprofile`, `.bash_profile`, `.bashrc`, `.profile`
- Shell platform split: `.global_profile` (all OSes), `.mac_profile` (Darwin), `.linux_profile` (Linux) — dispatched from `.profile` via `uname`; keep POSIX sh compatible
- Terminal/UI: `.wezterm.lua`, `.p10k.zsh`
- Editor/terminal configs: `.config/nvim/`, `.config/zed/`, `.config/zellij/`, `.config/alacritty/`, `.config/ghostty/`
- Helper scripts: `bin/` (single-purpose scripts, kebab-case)
- Activities: `activities/` (global activity manifest — see Activity System)

## Config Quick Map
Use this to jump straight to the right file for common instructions.
- Shell startup: `.zshrc`, `.zprofile`, `.profile`, `.bash_profile`, `.bashrc`
- Platform split: `.global_profile` (both), `.mac_profile` (macOS-only), `.linux_profile` (Linux-only)
- Shell prompt/theme: `.p10k.zsh`
- WezTerm: `.wezterm.lua`
- Zellij: `.config/zellij/`
- Neovim: `.config/nvim/`
- Zed: `.config/zed/`
- Alacritty: `.config/alacritty/`
- Ghostty: `.config/ghostty/`
- OpenCode: `.config/opencode/opencode.mac.json` / `opencode.linux.json` — tracked, platform-shared settings only. `opencode.json` (the global config opencode always loads, e.g. via `opencode mcp add`) is machine-local and git-untracked on purpose — MCP servers depend on locally-installed binaries, so keep them out of the repo.
- Herdr: `.config/herdr/config.template.toml` — tracked **template** only. `bin/herdr-config` renders a machine-local `~/.config/herdr/config.toml` (git-untracked, not stowed) from it, preserving this machine's `[theme]` so in-app theme changes (`prefix+b s`) never churn the repo. `bin/sync`/`bin/bootstrap` re-render it. Do not stow the live config.
- Pi: `.pi/agent/` (settings, keybindings, extensions; auth/sessions stay local)
- Cursor: `cursor/Library/Application Support/Cursor/User/`
- JetBrains GoLand: `jetbrains/Library/Application Support/JetBrains/GoLand2025.2/`
- Antigravity: `antigravity/`
- Helper scripts: `bin/`
- Local-only env: `~/.local/bin/env`

## Platform Split (mac / linux / global)
These dotfiles run on both macOS and Linux machines. Platform-dependent config must land in the right bucket:
- **global** — works everywhere
- **mac** — macOS-only (Darwin)
- **linux** — Linux-only

Linux targets are typically **headless servers** — do not assume a desktop/GUI is present. Don't
install desktop applications there, and when only part of a tool is useful on a server (a terminfo
entry, a CLI, a shared library), install that part rather than the whole GUI package. Reason about
whether each step makes sense on a headless box instead of mirroring what the Mac does.

This applies to shell setup and packages alike:
- Shell: `.global_profile` / `.mac_profile` / `.linux_profile`, dispatched from `.profile` via `uname`. Keep them POSIX sh compatible.
- Packages: `manifests/homebrew.json` splits `taps` and `formulae` into `{global, mac, linux}` objects. `casks` are macOS-only and stay a flat list.

## OS-Specific Bootstrap
Homebrew is the preferred package manager on both macOS and Linux.
On a greenfield machine, after the OS prerequisites below, `bin/bootstrap` runs the full setup
(brew packages, node + npm globals, bun, plannotator, stow). Manual/interactive steps (SSH, logins,
secrets) are listed in `docs/setup/manual.md`.

### macOS
1. Install Xcode CLT: `xcode-select --install`
2. Install Homebrew (if missing):
   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Ensure Homebrew on PATH: `eval "$(/opt/homebrew/bin/brew shellenv)"`
4. Install packages from `manifests/homebrew.json` (see Install Commands below)
5. Link dotfiles into `$HOME` using GNU Stow (see Linking Dotfiles)

### Linux
1. Install OS prerequisites via apt (the only apt step): `build-essential procps curl file git unzip uidmap`
2. Pre-create the prefix so the installer needs no sudo: `sudo install -d -o "$USER" -g "$(id -gn)" -m 0755 /home/linuxbrew`
3. Install Homebrew (Linuxbrew) — non-interactive and detached; the initial git fetch is ~450 MB and slow:
   `nohup env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /tmp/brew-install.log 2>&1 &`
   (x86_64 and aarch64 only; re-run the same command if it dies mid-fetch — it resumes)
4. Ensure Homebrew on PATH: `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"`
5. Run `bin/bootstrap` — it applies `manifests/homebrew.json` (formulae only; skips casks), installs GNU Stow from the manifest, links dotfiles (see Linking Dotfiles), and runs deterministic activities
6. If a dependency is missing for Homebrew itself, use the system package manager only to satisfy that prerequisite, then revert to Homebrew

`bin/sync` is NOT the greenfield entrypoint — it assumes brew + stow already exist. Full runbook: `activities/0000-activity-baseline.md`.

## Package Manifest
The package source of truth is `manifests/homebrew.json`. Do not edit generated lists in other files.
Node and global npm packages are pinned in `manifests/npm.json` (`bin/npm-install` applies them).
When installing software, prefer Homebrew first, then update `manifests/homebrew.json` to match the change.
Per the Platform Split principle, `taps` and `formulae` use the `{global, mac, linux}` schema — classify each
entry by where it works (`krunkit` is mac-only, for example). `casks` are macOS-only. `bin/brew-install`
merges `global` with the current platform's list automatically.
For non-brew installs, record the installation in `INSTALL.md` alongside any relevant version, date, and install command.

Installing a tool is not finished when the binary lands — it has two halves, and both belong here:
1. **Record the package** so it reinstalls everywhere (`manifests/homebrew.json`, or `INSTALL.md` for non-brew).
2. **Bring its config under management.** If the tool has any configuration — a config file, an rc, a
   shell-init snippet — stow it here at its mirrored `$HOME` path (e.g. under `.config/<tool>/`) or add
   the snippet to the right shell profile, so the tool behaves identically on every machine. A stowed
   binary that reads machine-local, untracked config is not reproducible. Skip this only when the tool
   genuinely has no config worth pinning.

Keep secrets, credentials, and machine-local state (history DBs, tokens, keys, caches) out of the repo —
those live under `~/.local/...` and are never committed (see Local-Only Files). Stow the config, not the data.

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

## Syncing Machines
Agents commit; the operator pushes. Never run `git push` yourself — leave the commit on the branch
and tell the operator it's ready to push.
After changing dotfiles on one machine, commit and tell the operator to push. Then apply everywhere else:
```sh
bin/sync
```
It pulls (ff-only, aborts if local changes are uncommitted), restows with `--no-folding`,
and reapplies the Homebrew and npm manifests. `bin/bootstrap` is for greenfield machines;
`bin/sync` is for existing ones.

## Activity System
System changes are tracked as activities — migration-like units that agents execute and log.

- **Global manifest**: `activities/NNNN-slug.md` (committed). All agents on all machines read it.
- **Machine state**: `~/.local/state/dotfiles/done/<id>.json` (local only, never commit).
- **Per-agent journal**: `~/.local/state/dotfiles/journal/<agent>.md` (local only, chmod 600). Agents never edit another agent's journal.

Each activity file has front matter — `id`, `kind: deterministic | inferential`,
`platform: global | mac | linux`, and for deterministic ones a single-line `run:` command — plus
a prose body explaining intent for inference. The `id` must equal the filename (without `.md`).

Manifest vs. activities — pick the right tool:
- **Packages belong in the manifest** (`manifests/*.json`), which is *declarative desired state*: a
  greenfield machine installs exactly what the manifest lists today. To remove a package, delete it
  from the manifest — greenfield then never installs it, and history is not replayed.
- **Activities are imperative and replay in order on every machine, including greenfield.** So never
  use an activity to install a package: if you later add an activity to uninstall it, a fresh machine
  would install-then-uninstall it. Reserve activities for state the manifest can't express — config
  outside the repo, terminfo, untapping, removing `~/.tool` dirs.
- **Make removal/cleanup activities guarded and idempotent** (`if brew list X`, `[ -e ]`, `rm -rf` a
  maybe-absent path) so they are no-ops on machines that never had the thing. Then greenfield stays
  clean even as activities accumulate: the manifest already omits the package, and the cleanup is a
  no-op.
- When the list grows long, supersede old entries with a fresh baseline (see
  `0000-activity-baseline`) instead of leaving install/undo pairs to replay forever.

Rules for agents:
- After completing any operator-requested system change, write a new activity describing it,
  commit it, and mark it done locally.
- Prefer `kind: deterministic` with a `run:` command (token-free, reproducible); use
  `inferential` only when the steps can't be scripted, and put instructions in the body.
- When the operator says "sync": run `bin/sync`, then process what's left with
  `bin/activities list --pending` — for each inferential activity, adapt it to this platform
  or mark `skipped` with a reason.
- After a sync, explicitly surface every action the operator still needs to take. Include shell
  reloads needed to activate newly installed shell integrations, pending/manual activities,
  warnings that require a decision, and any failed or skipped work. If nothing remains, say so.
- Always identify yourself: `DOTFILES_AGENT=<name> bin/activities mark <id> <done|skipped|failed> "note"`.
- Never mark an activity you haven't executed. `bin/sync` runs deterministic activities automatically.

Authoring an activity:
- **Pick the next number safely.** `git pull --ff-only` first, then use the next zero-padded 4-digit
  id after the highest one in `activities/` (e.g. `0003-<slug>`). If the operator's push is rejected because
  another machine claimed that number, rebase and renumber your file — activities are independent and
  order does not encode dependencies, so renumbering is safe.
- **`run:` commands must be idempotent.** Re-running one must be a no-op when the change is already in
  place (guard with `command -v`, `[ -f ]`, `mkdir -p`, etc.). Done-markers live in
  `~/.local/state/dotfiles` (machine-local, never committed); if that directory is lost, every
  activity re-runs, so a non-idempotent `run:` would double-apply.
- Keep `run:` on one line — the front-matter parser is line-based, not full YAML.

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

When committing multiple changes, group them logically into separate commits by theme rather than lumping unrelated changes together.
