# shellcheck shell=bash disable=SC1091,SC2206
# Baseline PATH for every zsh invocation, including non-interactive shells.
# Keep the BFFS Claude shim first so it always wins over real Claude binaries.
typeset -U path PATH
path=(
  "$HOME/.bffs/bin"
  "$HOME/.local/bin"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /home/linuxbrew/.linuxbrew/bin
  /home/linuxbrew/.linuxbrew/sbin
  "$HOME/.dotfiles/bin"
  /usr/local/bin
  $path
)
export PATH

# Rust/Cargo environment
[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# proto
export PROTO_HOME="$HOME/.proto";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";
