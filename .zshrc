autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Fallback for systems without xterm-ghostty terminfo
if [[ "$TERM" == "xterm-ghostty" ]] && ! infocmp xterm-ghostty &>/dev/null; then
  export TERM=xterm-256color
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load global + platform profiles (env, PATH, aliases, tool init).
# Login shells already did this via .zprofile; sourcing is idempotent.
# shellcheck source=/dev/null
source "$HOME/.profile"

# Zsh plugins from Homebrew (macOS and Linux prefixes)
_zsh_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
[ -f "$_zsh_share/powerlevel10k/powerlevel10k.zsh-theme" ] && source "$_zsh_share/powerlevel10k/powerlevel10k.zsh-theme"
[ -f "$_zsh_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$_zsh_share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# p10k prompt config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Syntax highlighting must be sourced last
[ -f "$_zsh_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$_zsh_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _zsh_share

# bun completions
[ -s "/home/rael/.bun/_bun" ] && source "/home/rael/.bun/_bun"
