---
id: 0010-set-linux-timezone
kind: deterministic
platform: linux
run: [ "$(timedatectl show -p Timezone --value)" = "Etc/GMT-8" ] || sudo -n timedatectl set-timezone Etc/GMT-8
---
# Set the Linux system timezone to UTC+8

Use the fixed-offset `Etc/GMT-8` IANA zone. The sign is intentionally reversed
by the `Etc/GMT` naming convention: `Etc/GMT-8` means UTC+8.
