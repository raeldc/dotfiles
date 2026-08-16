---
id: 0010-set-linux-timezone
kind: inferential
platform: linux
---
# Set the Linux system timezone

Ask the operator which timezone this machine should use, then apply it:

```sh
timedatectl set-timezone <zone>
```

`<zone>` is any IANA zone (`Asia/Singapore`, `Australia/Melbourne`, …) or a
fixed offset like `Etc/GMT-8`. The `Etc/GMT` sign convention is intentionally
reversed: `Etc/GMT-8` means UTC+8.

Needs sudo — see 0000 for how to drive sudo from an agent. Verify with
`timedatectl show -p Timezone --value`.

On Parallels guests, prefer matching the Mac host's timezone so both displays
agree; confirm with the operator before applying.
