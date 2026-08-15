---
id: 0006-remove-omlx-tap
kind: deterministic
platform: global
run: if command -v brew >/dev/null 2>&1 && brew tap 2>/dev/null | grep -qx jundot/omlx; then brew untap jundot/omlx; fi
---
# Untap jundot/omlx

oMLX was dropped from the setup and the `jundot/omlx` tap removed from the
Homebrew manifest. Machines that ran an earlier `bin/brew-install --taps` still
have the tap; this untaps it where present.

Idempotent (guarded by a tap presence check). Only untaps — no installed
formula/cask depends on it. The oMLX.app and its local model data (macOS-only,
manually installed) are not touched here.
