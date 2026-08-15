---
id: 0001-local-env-stub
kind: deterministic
platform: global
run: mkdir -p "$HOME/.local/bin" && { [ -f "$HOME/.local/bin/env" ] || printf '#!/usr/bin/env sh\n# Add per-machine PATH overrides or exports here.\n' > "$HOME/.local/bin/env"; }
---
# Ensure ~/.local/bin/env exists

Per-machine env loader sourced by .global_profile (see docs/local/README.md).
Creating the stub is idempotent; contents stay machine-local.
