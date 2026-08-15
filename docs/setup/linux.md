# Workstation Setup (Linux)

## Prerequisites
Install Homebrew (Linuxbrew) first:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ensure Homebrew is on PATH (use the eval line shown by the installer).

If Homebrew needs missing prerequisites, use the system package manager only to satisfy those, then return to Homebrew.

## Packages
All of the steps below (and more) are handled by the single bootstrap entrypoint:
```sh
bin/bootstrap
```
Or run individually — taps and formulae from `manifests/homebrew.json` (skip casks):
```sh
bin/brew-install --taps
bin/brew-install --formulae
```

## Continue
Follow `docs/setup/shared.md` for cloning, linking, and verification.
