---
name: gnu-stow
description: "Use when the user says stow, symlink, link dotfiles, restow, or unstow, or when any task needs GNU Stow to manage symlinks between a package directory and a target tree. Do not rely on training memory for Stow syntax or semantics — follow this skill. Based on the GNU Stow 2.4.1 manual (installed version; verify with `stow --version`)."
---

# GNU Stow

Stow is a symlink farm manager: each package directory holds an installation image mirroring the target tree, and Stow creates symlinks in the target pointing back into the package. Stow stores no state — ownership is recomputed from symlinks that point inside the stow directory.

Terminology (manual §2): **stow directory** (holds package dirs), **target directory** (where symlinks land), **package** (one dir inside the stow dir). Stow only ever creates symlinks inside the target that point outside it into the stow dir.

## This repo's layout

This dotfiles repo inverts the manual's classic layout: the **entire repo is one package** (`.`), the stow dir is `~/.dotfiles`, the target is `$HOME`. Canonical commands:

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" .
stow --no-folding --restow --dir="$HOME/.dotfiles" --target="$HOME" .
```

`bin/sync` runs the restow form. New dotfiles are linked by creating them at their mirrored `$HOME` path inside the repo, then restowing.

## Invocation rules

- Always pass `--dir` and `--target` explicitly. Never rely on cwd (no `cd <dir> && stow`); if a tool offers a working-directory parameter, use it.
- Default action is stow (`-S`). `-D` deletes (unstows) packages, `-R` restows (unstow then stow — prunes obsolete symlinks). `-D`/`-R` take effect on the package names that follow them; packages can be mixed in one invocation (`stow -D old -S new`).
- Preview before mutating: `stow -n -v --dir=... --target=... .` (`-n` simulates, `-v` explains).
- `stow --version` is the authority when behavior is in doubt. The manual lives at `https://www.gnu.org/software/stow/manual/stow.html`.

## Folding (manual §5)

By default Stow folds: if a target subtree would contain only symlinks to one package, it creates a single directory-level symlink instead. When a second package needs the same subtree, Stow unfolds it (replaces the symlink with a real dir plus per-file symlinks). Consequences for agents:

- This repo restows with `--no-folding`, so every file is an individual symlink. Do not assume folded (directory) symlinks exist, and do not introduce them.
- A symlinked *directory* in `$HOME` is normal Stow output under folding — never `rm` it or write files through it without checking. Writing through a folded-symlink dir lands files inside the repo package.
- On delete (`-D`), Stow refolds subtrees left containing only one package's links (unless `--no-folding`).

## Conflicts and safety (manual §7)

- Since 2.0 Stow is two-phase: it scans for conflicts first and aborts **before modifying anything** if any exist. A conflict means a non-Stow-owned file/dir blocks a symlink Stow needs. Never force past this by hand-deleting user files.
- When an app rewrites a stowed file in place (replacing the symlink with a real file — pi does this), restow reports `over existing target <path>`. That is a conflict, not a prompt to delete: back the real file up, then decide (repo wins vs. keep local). `bin/sync` already automates the backup path.
- Stow never deletes anything it doesn't own (manual §5.3). `-D` removes only Stow-owned symlinks/dirs.
- **Never use `--adopt`** without explicit operator approval: it *moves* target files into the repo package. It rewrites repo content by design.
- This repo does not use `--dotfiles` (the `dot-` prefix mapping); dotfiles live in the repo under their literal dotted names.

## Ignore lists (manual §4)

Stow skips VCS metadata and backup files via a built-in list, overridable per package with `.stow-local-ignore` or globally with `~/.stow-global-ignore` (one Perl regexp per line; `#` comments allowed). If a new file you added to the repo never links, check the ignore lists before anything else.

## Unstowing a single file

Stow operates on packages, not files — there is no "unstow this one file" flag. To take one path out of management (as was done for `.pi/agent/settings.json`):

1. Copy the live content aside (`cp -L` to follow the symlink).
2. Replace the `$HOME` symlink with a real file holding that content.
3. `git rm` the path from the repo and re-ignore it if the surrounding ignore rules un-ignore it.
4. Restow to verify clean, then commit.
5. If other machines need the same migration, record it as a deterministic activity (guarded on `[ -L ... ]`, idempotent), not as a Stow operation.

## Diagnostics

- `chkstow -t "$HOME" --badlinks` finds dangling symlinks (e.g. left behind after a repo-side `git rm`).
- `chkstow -t "$HOME" --list` shows which package each target symlink points to.
- `ls -la` on the exact path always beats guessing whether something is a symlink, a real file, or a folded dir.
