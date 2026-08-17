---
id: 0014-allow-rootless-podman-userns
kind: deterministic
platform: linux
run: [ "$(sysctl -n kernel.apparmor_restrict_unprivileged_userns 2>/dev/null)" = "0" ] || { sudo -n sysctl -w kernel.apparmor_restrict_unprivileged_userns=0 && { [ -f /etc/sysctl.d/99-unprivileged-userns.conf ] || echo 'kernel.apparmor_restrict_unprivileged_userns=0' | sudo -n tee /etc/sysctl.d/99-unprivileged-userns.conf >/dev/null; }; }
---
# Allow rootless Podman user namespaces on Linux

Ubuntu 24.04+ sets `kernel.apparmor_restrict_unprivileged_userns=1` by default,
which blocks the user namespace that rootless Podman needs. Symptom: the brew
`podman` service exits with `failed to reexec: Permission denied`, and
`unshare --user --map-root-user true` fails with "write failed /proc/self/uid_map:
Operation not permitted".

Fix (one-time, persists across reboots):

  sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
  echo 'kernel.apparmor_restrict_unprivileged_userns=0' | sudo tee /etc/sysctl.d/99-unprivileged-userns.conf
  sudo sysctl --system

The run command is idempotent: it no-ops when the sysctl is already 0, and
otherwise sets it live plus writes the `/etc/sysctl.d` drop-in. It uses `sudo -n`
so on a machine without passwordless sudo the operator must prime sudo or apply
the three lines by hand (see 0000 for driving sudo from an agent).

Verify: `sysctl kernel.apparmor_restrict_unprivileged_userns` prints 0, and
`podman info` no longer errors on userns. Then `bin/podman-setup` should bring up
`$XDG_RUNTIME_DIR/podman/podman.sock`.
