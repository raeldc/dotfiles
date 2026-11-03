---
id: 0025-migrate-terraform-to-mise
kind: deterministic
platform: global
run: mise -C "$HOME" install terraform && "$HOME/.local/share/mise/shims/terraform" version >/dev/null && { if command -v brew >/dev/null 2>&1 && brew list --formula terraform >/dev/null 2>&1; then brew uninstall terraform; fi; }
---
# Manage Terraform with mise

Terraform's shared default is pinned in `.config/mise/config.toml`; project
configs can override it. Bootstrap and sync install the configured version.
After checking the mise shim works, remove any Homebrew Terraform copy so it
cannot shadow the shim. Machines without the Homebrew formula are unchanged.
