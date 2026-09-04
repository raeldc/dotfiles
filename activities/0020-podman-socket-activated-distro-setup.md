---
id: 0020-podman-socket-activated-distro-setup
kind: deterministic
platform: linux
run: bin/podman-setup
---
# Socket-activated Podman with per-distro providers

Replaces the Homebrew long-lived `podman system service` (activities 0013,
0019) with real socket activation, dispatched by distro. Rationale: without a
`podman.socket` unit, any service death leaves a stale socket file behind and
every `DOCKER_HOST` client breaks until a manual restart. With socket
activation the socket is owned by systemd, survives service death, and the
service starts on demand — verified with `kill -9` (new PID on next
connection, socket file never goes missing).

Providers (`bin/podman-setup`, idempotent — safe to re-run via bin/sync and
bin/bootstrap, which already call it):
- Arch (incl. ID_LIKE=arch): `pacman -S podman podman-docker` (latest +
  native units + docker CLI shim); removes the brew copy if present; enables
  the distro `podman.socket`. Needs passwordless sudo, else it prints the
  manual command and exits non-zero.
- Other Linux (Ubuntu): brew podman (latest — apt is frozen at 4.9 and Kubic
  has no noble builds) + generated `~/.config/systemd/user/podman.socket` /
  `podman.service` (upstream content, ExecStart pointed at the stable brew
  symlink); retires `homebrew.podman.service` and the 0019 drop-in.
- macOS: unchanged `podman machine` path (same script, Darwin branch).

Gotcha baked into the script: the generated service MUST set
`PATH=<brew-prefix>/bin:...` — brew's conmon/crun/netavark live outside
podman's compiled-in helper paths, and without it the service exits 125
("could not find a working conmon binary"), tripping the socket trigger
limit. This is what the old `homebrew.podman` unit provided implicitly.

Companion changes (same theme, committed alongside): `podman` formula moved
from `global` to `mac` in `manifests/homebrew.json` (linux providers are
per-distro now); `alias docker=podman` fallback in `.linux_profile` when no
real `docker` shim exists (mac already had it); 0019 drop-in deleted.

`DOCKER_HOST` is unchanged (`$XDG_RUNTIME_DIR/podman/podman.sock`), so
lazydocker / podman-tui / docker CLI consumers need no updates. Requires
user linger (`loginctl enable-linger`) so the socket persists without login;
the script warns when it is off.

Verify: `systemctl --user status podman.socket` shows active (listening);
`curl -s --unix-socket "$XDG_RUNTIME_DIR/podman/podman.sock"
http://localhost/_ping` prints OK; `podman.tui` and lazydocker connect.
NOTE: only the Ubuntu path has been executed (this host). The Arch path is
written but untested — let it run via sync on an Arch box before calling it
fully done there.
