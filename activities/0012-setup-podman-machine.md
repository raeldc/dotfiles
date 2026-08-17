---
id: 0012-setup-podman-machine
kind: deterministic
platform: global
run: bin/podman-setup
---
# Initialize and start the default Podman machine

The package manifest installs Podman plus the required Linux QEMU and
`virtiofsd` dependencies. Bootstrap and sync install the pinned Linux `gvproxy`
helper before activities run. This activity creates the default Podman VM when
absent and starts it when stopped, leaving an already-running machine unchanged.
On Linux it also grants the current user access to `/dev/kvm` through the `kvm`
group and applies that group for the setup run without requiring an intervening
login.
