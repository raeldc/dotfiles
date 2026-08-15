---
id: 0002-ghostty-terminfo
kind: inferential
platform: linux
---
# Install the xterm-ghostty terminfo entry on Linux (NOT the Ghostty app)

Do NOT install the Ghostty desktop app — these are typically headless Linux
servers. The only thing needed here is the `xterm-ghostty` terminfo *entry* (a
few-KB terminal capability description), so that SSH sessions from a Ghostty
terminal (which sets `TERM=xterm-ghostty`) handle keys correctly on this box.

This is a fidelity nice-to-have, not required: `.global_profile` already falls
back to `xterm-256color` when the entry is missing, so the shell works either
way.

Check first:
  infocmp xterm-ghostty >/dev/null 2>&1 && echo present

If missing, install just the terminfo entry for the current user (no app, no
root):
  curl -fsSL https://raw.githubusercontent.com/ghostty-org/ghostty/main/src/terminfo/ghostty.terminfo | tic -x -

Prefer a distro package that ships the terminfo entry if one exists. If you
can't install it, mark skipped — the xterm-256color fallback keeps the shell
working. Not applicable on macOS (the Ghostty cask ships terminfo).
