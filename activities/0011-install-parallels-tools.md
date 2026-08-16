---
id: 0011-install-parallels-tools
kind: inferential
platform: linux
---
# Install Parallels Tools on Linux guests

Linux VMs hosted by Parallels Desktop need the guest tools for shared folders
(`/media/psf/`), clipboard/drag-and-drop, and host-driven VM state. They are
not installed by Homebrew or apt, and the installer ISO can only be inserted
from the Mac host — so this can't be a deterministic activity.

## Detect whether this machine is a Parallels guest

If none of these hold, mark this activity `skipped` ("not a Parallels VM"):

- `/sys/devices/platform/` contains a `PRL` device (e.g. `PRL4010:00`)
- `systemctl list-units` shows `prltoolsd.service` (already installed)

## Install (only on a Parallels VM without the tools)

1. **Operator action on the Mac host** — insert the tools ISO:
   - CLI: `prlctl installtools "<vm-name>"`
   - GUI: Parallels menu → Actions → "Install Parallels Tools…"
2. In the guest (needs sudo; see 0000 for driving sudo from an agent):
   ```sh
   sudo mkdir -p /mnt/cdrom
   sudo mount /dev/sr0 /mnt/cdrom
   cd /mnt/cdrom && sudo ./install
   ```
   Prereqs: `build-essential` and `linux-headers-$(uname -r)` (the headers are
   not in the bootstrap apt list — `sudo apt install linux-headers-$(uname -r)`
   first if missing).
3. Verify: `systemctl is-active prltoolsd.service` → `active`, and
   `/media/psf/` exists. Shared folders configured in Parallels VM settings
   appear under `/media/psf/<name>`.

## Notes

- Operator preference: keep Parallels host time sync OFF so the guest's chrony
  owns its clock: on the Mac run `prlctl set "<vm-name>" --sync-host-time off`.
- Tools version comes from the host's Parallels install (ISO carries it); the
  version installed here is recorded in `INSTALL.md`. Upgrade = re-run the
  same flow after a Parallels Desktop update.
- The installer generates its own config (`/etc/parallels-tools.conf` etc.) —
  nothing to stow.
