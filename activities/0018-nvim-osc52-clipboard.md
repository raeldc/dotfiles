---
id: 0018-nvim-osc52-clipboard
kind: deterministic
platform: global
run: test -f .config/nvim/lua/options.lua && grep -q "OSC 52" .config/nvim/lua/options.lua
---

# Nvim OSC 52 clipboard inside herdr

Yanking in nvim running inside a herdr pane previously stayed in nvim's
internal registers on machines with no clipboard provider (headless Linux,
no `$DISPLAY` / `$WAYLAND_DISPLAY`).

`.config/nvim/lua/options.lua` now installs a `vim.g.clipboard` provider
named "OSC 52" when no native display is detected. The provider emits an
OSC 52 sequence (`ESC ]52;c;<base64>`), which herdr forwards from the pane
PTY to the attached client terminal (Ghostty/WezTerm), which writes it to
the system clipboard. Combined with NvChad's default `clipboard=unnamedplus`,
plain `y` lands in the system clipboard everywhere.

Paste via OSC 52 is not wired (provider paste returns empty); use herdr's
own paste for that. On local machines with a display, the native
pbcopy/xclip/wl-copy provider is used instead.
