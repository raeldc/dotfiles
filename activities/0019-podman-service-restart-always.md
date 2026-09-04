---
id: 0019-podman-service-restart-always
kind: deterministic
platform: linux
run: systemctl --user cat homebrew.podman.service >/dev/null 2>&1 && { systemctl --user daemon-reload; systemctl --user start homebrew.podman.service; } || true
---
# Restart the Podman API service on failure

On 2026-09-04 the Homebrew `homebrew.podman` user service was OOM-killed and
stayed `failed` — the Homebrew-generated unit ships no `Restart=` policy. The
stale `$XDG_RUNTIME_DIR/podman/podman.sock` kept its old mtime with no
listener behind it, so Docker-API clients (lazydocker) failed with "Cannot
connect to the Docker daemon".

Fix: a stowed systemd drop-in at
`.config/systemd/user/homebrew.podman.service.d/override.conf` sets
`Restart=always` + `RestartSec=5`. A drop-in (not an edit of the generated
unit) survives `brew reinstall podman`. Verified with a `kill -9` of the
service PID: systemd restarted it (`NRestarts=1`) and `/_ping` returned `OK`.

The run command is idempotent: it no-ops on machines without the unit
(greenfield before podman is installed — the orphan drop-in is harmless),
`daemon-reload` picks up the drop-in, and `start` is a no-op when already
running.

Verify: `systemctl --user show homebrew.podman.service -p Restart` prints
`Restart=always`, and
`curl -s --unix-socket "$XDG_RUNTIME_DIR/podman/podman.sock" http://localhost/_ping`
prints `OK`.
