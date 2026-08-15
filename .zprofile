# Load env + platform profiles for login shells.
# Sourced natively (no sh emulation): the profiles gate shell-specific
# sections on ZSH_VERSION/BASH_VERSION, which sh emulation breaks.
source "$HOME/.profile"
