---
id: 0002-ghostty-terminfo
kind: inferential
platform: linux
---
# Ghostty terminfo on Linux

Ghostty sets TERM=xterm-ghostty. Linux machines without Ghostty installed
lack this terminfo entry, degrading keys over ssh/tmux (shell configs fall
back to xterm-256color).

Check first:
  infocmp xterm-ghostty >/dev/null 2>&1 && echo present

If missing, install the entry for the current user:
  curl -fsSL https://raw.githubusercontent.com/ghostty-org/ghostty/main/src/terminfo/ghostty.terminfo | tic -x -

Prefer a distribution package if one provides it. If neither is possible,
mark skipped with a reason. macOS ships terminfo with the Ghostty cask —
nothing to do there (this activity does not apply on mac).
