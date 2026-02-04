# Dotfiles Setup Guide

This repo mirrors `$HOME` and is symlinked into place on a new machine.

## Quickstart
- Canonical agent onboarding: `AGENTS.md`
- macOS setup: `docs/setup/macos.md`
- Linux setup: `docs/setup/linux.md`
- Shared setup steps: `docs/setup/shared.md`
- Local-only config contract: `docs/local/README.md`

## Package Manifest
The package source of truth is `manifests/homebrew.json`. Use `bin/brew-install` to install taps, formulae, and casks.
