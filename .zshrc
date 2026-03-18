autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

EDITOR='nvim'

# fzf
command -v fzf >/dev/null && source <(fzf --zsh)
alias fvim='nvim $(fzf -m --preview="bat --color=always {}")'

# Load Angular CLI autocompletion.
#source <(ng completion script)
export PATH="/usr/local/opt/pnpm@8/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#p10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# eza
alias ls="eza --color=always --icons=always --no-time --no-permissions --no-user"

# vim
# alias vim='nvim'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias lzd='lazydocker'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# colima
alias docker-start='colima start --mount-type 9p'

# podman as docker drop-in replacement
alias docker='podman'
export DOCKER_HOST="unix://${TMPDIR}podman/podman-machine-default-api.sock"

. "$HOME/.local/bin/env"

complete -o nospace -C /opt/homebrew/bin/terraform terraform

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# devbox
alias psmnd-cf="ssh -o ProxyCommand=\"cloudflared access ssh --hostname rael.psmnd.dev\" rael@rael.psmnd.dev&"

alias psmnd-vm="ssh -o ProxyCommand=\"cloudflared access ssh --hostname rael.psmnd.dev\" rael@rael.psmnd.dev"

# pnpm
export PNPM_HOME="$HOME/l/homebrew/bin/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Paths
export PATH="~/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"



# bun completions
[ -s "/Users/rael/.bun/_bun" ] && source "/Users/rael/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load dotfiles .env (gitignored, machine-local)
if [[ -f "$HOME/.dotfiles/.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$HOME/.dotfiles/.env"
  set +a
fi

# opencode
export PATH=/Users/rael/.opencode/bin:$PATH

# Disable false-positive warning in snapshot-restored shells (e.g. Claude Code)
export _ZO_DOCTOR=0
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
