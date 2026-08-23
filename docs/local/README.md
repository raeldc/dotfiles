# Local-Only Files

Use local-only files for machine-specific settings, secrets, or paths. Do not commit these to Git.

## Environment loader
Create `~/.local/bin/env` for per-machine exports.
```sh
mkdir -p "$HOME/.local/bin"
cat <<'EOF' > "$HOME/.local/bin/env"
#!/usr/bin/env sh
# Add per-machine PATH overrides or exports here.
EOF
chmod +x "$HOME/.local/bin/env"
```

## Machine-local profile
Create `~/.local_profile` for machine-local commands and aliases, e.g. SSH
shortcuts. It is gitignored and sourced last by `~/.profile`, so it can
override global and platform aliases.
```sh
[ -f "$HOME/.local_profile" ] || printf '# shellcheck shell=sh\n# Machine-local commands and aliases.\n' > "$HOME/.local_profile"
[ -L "$HOME/.local_profile" ] || ln -sfn .dotfiles/.local_profile "$HOME/.local_profile"
```

## Notes
- Keep tokens, SSH configs, and machine-specific values out of this repo.
- Add guards in shell files for optional tools to avoid login errors.
- `~/.local/bin/env` is for per-machine exports; `~/.local_profile` is for per-machine commands, aliases, and functions.
