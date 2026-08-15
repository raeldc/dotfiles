---
id: 0008-use-zsh-login-shell
kind: inferential
platform: linux
---
# Use Linuxbrew Zsh as the Linux login shell

The shared prompt, plugins, and shell integrations are configured in `.zshrc`.
Linux accounts commonly default to Bash, so make the Homebrew-managed Zsh from
the formula manifest the login shell after it has been installed.

Resolve the executable from Homebrew and verify it exists:

  zsh_path="$(brew --prefix)/bin/zsh"
  [ -x "$zsh_path" ]

Add it to `/etc/shells` if needed, then change the current user's login shell.
These commands require administrator privileges on most Linux systems:

  grep -Fxq "$zsh_path" /etc/shells || sudo add-shell "$zsh_path"
  [ "$(getent passwd "$USER" | cut -d: -f7)" = "$zsh_path" ] || sudo chsh -s "$zsh_path" "$USER"

Verify with `getent passwd "$USER"`. The new shell takes effect on the next
login; use `exec "$zsh_path" -l` to activate it in the current terminal.
