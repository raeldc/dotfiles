# shellcheck shell=sh
# ~/.profile — loads global + platform-specific shell setup
# Sourced by .zprofile (zsh login), .bash_profile (bash login), and .zshrc/.bashrc.

# shellcheck source=/dev/null
. "$HOME/.global_profile"

case "$(uname -s)" in
  Darwin)
    # shellcheck source=/dev/null
    [ -f "$HOME/.mac_profile" ] && . "$HOME/.mac_profile"
    ;;
  Linux)
    # shellcheck source=/dev/null
    [ -f "$HOME/.linux_profile" ] && . "$HOME/.linux_profile"
    ;;
esac
