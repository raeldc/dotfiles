---
id: 0022-cap-journald-size
kind: deterministic
platform: linux
run: grep -qs '^SystemMaxUse=500M$' /etc/systemd/journald.conf.d/size.conf || { sudo mkdir -p /etc/systemd/journald.conf.d && printf '[Journal]\nSystemMaxUse=500M\n' | sudo tee /etc/systemd/journald.conf.d/size.conf >/dev/null && sudo systemctl restart systemd-journald; }
---
# Cap the systemd journal at 500M

Ubuntu ships journald with no explicit `SystemMaxUse`, so the default (10% of
the filesystem, up to 4G) let `/var/log/journal` reach 2.2G on a 247G disk.
A drop-in at `/etc/systemd/journald.conf.d/size.conf` sets
`SystemMaxUse=500M`; journald then rotates and vacuums on its own.

Idempotent: no-op when the drop-in already holds the cap. Needs sudo.

Verify: `journalctl --disk-usage` reports under 500M.
