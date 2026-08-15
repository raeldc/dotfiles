---
id: 0000-activity-baseline
kind: inferential
platform: global
---
# Activity-system baseline

Everything done before the activity system existed (2026-08-15) is baseline:
shell profiles, brew/npm manifests, bootstrap, sync, pi config. Do not re-run
history on machines that predate this system.

If this machine is already operational (bin/sync completes cleanly, shell
works), mark this activity done with note "baseline acknowledged".

On a greenfield machine, run bin/bootstrap first, then mark done.
