---
name: herdr-state
description: Save Herdr session state to disk. Use when the operator says "save herdr state" or asks what is open in Herdr — workspaces, tabs, panes, and the processes running inside them.
---

# Herdr State

Snapshot the live Herdr session (workspaces, tabs, panes with labels, cwd, and
agent status, plus the foreground process in each pane) into the machine-local,
gitignored `.local/herdr/` directory.

## When to Activate

- Operator says "save herdr state".
- Operator asks what is open/running in Herdr and the answer should be persisted.

## Procedure

Must run inside a Herdr pane (`HERDR_ENV=1`). One command does the whole dump:

```sh
bin/herdr-snapshot
```

It writes `.local/herdr/herdr-state-<UTC>.json` and refreshes
`.local/herdr/latest.json`. That directory is gitignored and never stowed —
machine-local state, not config. Never commit snapshots.

## Snapshot Schema

Top-level keys in each snapshot file:

- `taken_at_utc` — ISO-8601 timestamp of the dump.
- `snapshot` — the raw `herdr api snapshot` document. Workspaces carry `label`,
  tabs carry `label`, panes carry `pane_id`, `tab_id`, `workspace_id`, `cwd`,
  `foreground_cwd`, `agent` / `agent_status`, and `terminal_title`.
- `process_info_by_pane` — map of `pane_id` to `herdr pane process-info`
  output: `foreground_processes` (argv, pid, cwd, name), `shell_pid`,
  `foreground_process_group_id`. A pane that could not be read carries an
  `error` key instead — the snapshot is still written.

## Manual Inspection

For a live look without writing a file:

```sh
herdr api snapshot | python3 -m json.tool | head -n 100
herdr workspace list
herdr pane process-info --pane <pane-id>
```
