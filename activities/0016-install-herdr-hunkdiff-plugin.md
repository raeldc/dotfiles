---
id: 0016-install-herdr-hunkdiff-plugin
kind: deterministic
platform: global
run: if command -v herdr >/dev/null 2>&1 && ! herdr plugin list 2>/dev/null | grep -q jhochenbaum.hunkdiff; then herdr plugin install jhochenbaum/herdr-hunk-diff --yes; fi
---
# Install the herdr hunk diff plugin

Installs `jhochenbaum/herdr-hunk-diff` (plugin id `jhochenbaum.hunkdiff`), which
wires the `hunk` diff viewer (brew formula, see `manifests/homebrew.json`) into
herdr as review panes for agent-authored changesets (`review`, `review:staged`,
`review:branch`, … actions and panes).

The plugin is fetched from GitHub by herdr itself and lives machine-local under
`~/.config/herdr/plugins/` — nothing to stow. The `run:` guard makes it a no-op
once `herdr plugin list` reports the plugin, so re-runs (and greenfield replays)
are safe. Requires node/npm for its build steps (`npm ci && npm run build`);
node comes from `manifests/npm.json` via `bin/bootstrap`.

Verify with:

```sh
herdr plugin list   # jhochenbaum.hunkdiff (hunk) enabled
```

## Post-install: default keybindings

The plugin ships default keybindings but does not install them automatically.
Opt in per machine with its `setup-keys` action:

```sh
herdr plugin action invoke setup-keys --plugin jhochenbaum.hunkdiff
herdr server reload-config
```

This was run on the installing machine; run it by hand on other machines after
`bin/sync` installs the plugin if you want the bindings there too.
