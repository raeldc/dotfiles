---
id: 0015-upgrade-bun
kind: deterministic
platform: global
run: command -v bun >/dev/null 2>&1 && bun upgrade || true
---
# Upgrade Bun

Upgrade the user-local Bun installation managed by Bun's official installer to
the latest stable release. The command is safe to replay and skips machines
where Bun is not installed yet.
