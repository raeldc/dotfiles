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

## Greenfield runbook (Linux)

`bin/sync` assumes `brew` and `stow` already exist — it is NOT the greenfield
entrypoint. On a fresh Linux machine, do this instead (learned on Ubuntu 26.04
arm64, 2026-08-16):

1. **OS prerequisites via apt** (the only apt installs; everything else is brew):
   `sudo apt-get install -y build-essential procps curl file git unzip uidmap`
   (`unzip` is needed by the bun installer later; `uidmap` provides
   `newuidmap`/`newgidmap` that rootless podman requires on Linux.)
2. **Pre-create the Homebrew prefix** so the installer needs no sudo:
   `sudo install -d -o "$USER" -g "$(id -gn)" -m 0755 /home/linuxbrew`
3. **Install Homebrew detached and non-interactively.** The installer fetches
   the full Homebrew/brew git history (~450 MB) — 30-60+ min on slow links.
   Run it with nohup and a log file so an agent tool timeout cannot kill it:
   `nohup env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /tmp/brew-install.log 2>&1 &`
   If it dies mid-fetch, re-run the same command; the installer resumes.
   Linux install targets x86_64 and aarch64 only.
4. **Run `bin/bootstrap`.** It applies the brew manifest (this also installs
   GNU stow), the npm manifest, bun, plannotator, stows the dotfiles, and runs
   deterministic activities.
5. **Sudo-requiring remainder**: login shell (0008), /usr/local/bin/zsh (0009),
   timezone (0010). See below for how to drive sudo from an agent.
6. **Render the herdr config**: `bin/herdr-config`. On first sync/bootstrap the
   render step is skipped because herdr is only installed by the brew manifest
   later in the same run; the next sync would render it, but run it once by hand
   to avoid waiting.

Agent notes for sudo on greenfield:
- Agent bash sessions are non-TTY: sudo cannot prompt, and sudo timestamps do
  NOT persist across tool calls (timestamp_type=tty). Either ask the operator
  to run the sudo one-liners, or pipe the password per invocation:
  `printf '%s\n' "$pw" | sudo -S -p '' <cmd>` (never write it to disk).
- Deterministic activities that need sudo use `sudo -n` (e.g. 0010). Pre-satisfy
  them by hand (as above) or prime sudo in the same shell invocation; the
  activity's idempotence guard then makes its run a no-op success.

On a greenfield machine, once the runbook above is done, mark done.
