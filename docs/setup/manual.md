# Manual / Interactive Setup Steps

These can't be automated (secrets, logins, hardware prompts). An agent setting up a
greenfield machine should prompt the operator for each item below.

## SSH + GitHub
1. Generate a key if missing: `ssh-keygen -t ed25519 -C "rael"`
2. Add to ssh-agent and GitHub, then test: `ssh -T git@github.com`
3. If using the `rael.github.com` host alias, add it to `~/.ssh/config` (machine-local, never commit)
   and update the origin URL (see `shared.md`).

## Tool logins / auth
Run each and follow the browser prompt:
```sh
pi login          # or: pi auth
gh auth login
```
Other agents (opencode, codex, claude-code, gemini, auggie) — log in on first use
or import keys via each tool's auth flow.

## Secrets
- `~/.dotfiles/.env` — repo-local secrets (gitignored, auto-sourced)
- `~/.local/bin/env` — per-machine exports (see `docs/local/README.md`)

## macOS app logins (manual)
Raycast, Bitwarden, Ghostty/WezTerm sync, browser sign-ins — do these by hand.

## Nice-to-have (not automated)
- `~/l/homebrew` — legacy pnpm home (only if tools expect it; brew `pnpm` is the canonical one)
- Time Machine / backup setup
