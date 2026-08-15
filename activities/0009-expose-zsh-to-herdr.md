---
id: 0009-expose-zsh-to-herdr
kind: inferential
platform: linux
---
# Expose Zsh to Herdr's remote server environment

Herdr servers launched directly over SSH inherit sshd's minimal PATH and do not
source `.profile`. The managed Herdr config launches `zsh` for new panes, so Zsh
must be resolvable from a typical system PATH such as
`/usr/local/bin:/usr/bin:/bin`.

First check whether that environment already has a usable Zsh:

  PATH=/usr/local/bin:/usr/bin:/bin command -v zsh

If it does not, verify Linuxbrew Zsh is installed and expose it through
`/usr/local/bin`:

  zsh_path="$(brew --prefix)/bin/zsh"
  [ -x "$zsh_path" ]
  [ ! -e /usr/local/bin/zsh ] && sudo ln -s "$zsh_path" /usr/local/bin/zsh

Do not replace an existing `/usr/local/bin/zsh` without checking what owns it.
After changing the path, run `herdr server reload-config` when a server is
running. New panes should report Zsh from `herdr pane process-info <pane-id>`.
