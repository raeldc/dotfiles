export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"
. "$HOME/.local/bin"

if [ -z "${OPENCODE_CONFIG-}" ]; then
  case "$(uname -s)" in
    Darwin) OPENCODE_CONFIG="$HOME/.config/opencode/opencode.mac.json" ;;
    Linux) OPENCODE_CONFIG="$HOME/.config/opencode/opencode.linux.json" ;;
  esac
  export OPENCODE_CONFIG
fi
