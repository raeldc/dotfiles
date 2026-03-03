

. "$HOME/.local/bin/env"

complete -C /opt/homebrew/bin/terraform terraform

# podman as docker drop-in replacement
alias docker='podman'
export DOCKER_HOST="unix://${TMPDIR}podman/podman-machine-default-api.sock"

# Load dotfiles .env (gitignored, machine-local)
if [ -f "$HOME/.dotfiles/.env" ]; then
  set -a
  # shellcheck source=/dev/null
  . "$HOME/.dotfiles/.env"
  set +a
fi
