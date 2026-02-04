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

## Notes
- Keep tokens, SSH configs, and machine-specific values out of this repo.
- Add guards in shell files for optional tools to avoid login errors.
