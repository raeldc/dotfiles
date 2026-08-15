---
id: 0005-remove-kilocode
kind: deterministic
platform: global
run: rm -rf "${HOME:?}/.kilocode"
---
# Remove the Kilocode home directory

Kilocode was dropped from the setup: `.kilocode/` is gone from the repo, so on
other machines the stowed `~/.kilocode` config symlinks now dangle and its
local runtime (node_modules, cli state) is dead weight. `~/.kilocode` is a
single-tool directory with no data worth keeping, so remove it wholesale.

The repo removal itself propagates via git — this activity only handles the
out-of-repo `~/.kilocode` directory. Idempotent (rm -rf of a missing path is a
no-op); the `${HOME:?}` guard refuses to run if HOME is unset.
