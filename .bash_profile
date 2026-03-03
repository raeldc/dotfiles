

. "$HOME/.local/bin/env"

complete -C /opt/homebrew/bin/terraform terraform

# Load dotfiles .env (gitignored, machine-local)
if [ -f "$HOME/.dotfiles/.env" ]; then
  set -a
  # shellcheck source=/dev/null
  . "$HOME/.dotfiles/.env"
  set +a
fi
