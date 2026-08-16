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

If missing, recompile the distro's `ghostty` entry under the `xterm-ghostty`
name into the user terminfo db (no app, no root). ncurses-term (Ubuntu/Debian)
ships a `ghostty` entry but not the `xterm-ghostty` name Ghostty actually
exports as TERM:
  infocmp ghostty | sed 's/^ghostty|/xterm-ghostty|/' | tic -x -

Verify with `infocmp xterm-ghostty` (lands in ~/.terminfo/x/).

NOTE: the old recipe (`curl .../ghostty-org/ghostty/main/src/terminfo/ghostty.terminfo
| tic -x -`) is dead — upstream removed the static file; the entry is now
generated from Zig source at build time. Do not resurrect that URL.

If the distro has no `ghostty` entry either (older ncurses), extract the
`xterm-ghostty` stanza from ncurses' terminfo.src or copy ~/.terminfo from a
machine that has it. If you can't install it, mark skipped — the xterm-256color
fallback keeps the shell working. Not applicable on macOS (the Ghostty cask
ships terminfo).
