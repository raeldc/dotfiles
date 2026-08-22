---
id: 0017-remove-gastownhall-beads-tap
kind: deterministic
platform: global
run: [ -d "$(brew --prefix)/Cellar/bd" ] && brew uninstall bd || true; brew tap | grep -qx gastownhall/beads && brew untap gastownhall/beads || true
---
# Remove gastownhall/beads tap

Untapped and removed after the operator decided to stop using it. The `bd`
formula from this tap was never installed in the Cellar on this machine, but
other machines may have it — the run command uninstalls the formula first if a
keg exists, then untaps. Both steps are guarded, so machines that never had the
tap are no-ops.
