# Workstation Setup (macOS)

## Prerequisites
1. Install Xcode CLT:
   ```sh
   xcode-select --install
   ```
2. Install Homebrew (if missing):
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Ensure Homebrew on PATH:
   ```sh
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

## Packages
All of the steps below (and more) are handled by the single bootstrap entrypoint:
```sh
bin/bootstrap
```
Or run individually — taps, formulae, then casks from `manifests/homebrew.json`:
```sh
bin/brew-install --taps
bin/brew-install --formulae
bin/brew-install --casks
```

## Continue
Follow `docs/setup/shared.md` for cloning, linking, and verification.
