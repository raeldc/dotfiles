---
id: 0013-use-native-podman-on-linux
kind: deterministic
platform: linux
run: bin/podman-native-migrate
---
# Use native Podman on Linux

Linux runs Podman natively and exposes its Docker-compatible API through a
persistent Homebrew service. Remove the unnecessary Podman VM, QEMU stack,
standalone `gvproxy`, and KVM group access introduced by the superseded machine
setup. macOS continues to use Podman Machine.
