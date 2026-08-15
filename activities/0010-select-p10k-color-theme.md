---
id: 0010-select-p10k-color-theme
kind: inferential
platform: linux
---
# Select a machine-local Powerlevel10k color theme

Powerlevel10k color themes are tracked under `.config/p10k/themes/`, while the
selection is machine-local. Set the desired theme in `~/.local/bin/env` without
overwriting any existing local settings.

The available theme is `terminal`, which uses the host terminal's ANSI palette
like Herdr's built-in theme of the same name:

  export P10K_COLOR_THEME=terminal

Leave `P10K_COLOR_THEME` unset to retain the generated Powerlevel10k defaults.
Start a new Zsh login shell after selecting a theme. If the instant prompt briefly
uses old colors, remove `~/.cache/p10k-instant-prompt-*` and restart Zsh.
