# FAQ

## Why not just use `>> file.log`?

Redirection is useful but manual. `ld` keeps your normal terminal workflow and gives one-command clipboard copy (`ld c`) after recording.

## Does this log all terminal tabs automatically?

No. Logging is session-scoped. You choose where to capture by running `ld start` in that shell.

## What if `ld c` says no clipboard tool found?

Install one of the supported tools (`wl-copy`, `xclip`, `xsel`, `pbcopy`, `clip.exe`) and retry. Your log file still exists and can be viewed with `ld show`.
`ld c` returns exit code `21` in this scenario, which is useful for scripts.

## Where is my latest log stored?

The path is tracked in `~/.local/state/ld/current_log`. Use `ld status` or `ld show`.

## How do I uninstall?

Run:

```bash
~/.config/ld/uninstall.sh
```

Then open a new terminal.

## Why does the README still say `source` after install?

A script started as `./install.sh` runs in a **child process**. It can write files and edit your `~/.bashrc`, but it cannot inject functions into the **parent** shell. Loading `ld` in the current session requires either `source ~/.config/ld/ld.sh`, or running **`source ./install.sh`** from **bash** (see README), or opening a **new** terminal so your rc file runs.

## What does "recorder state is inconsistent" mean?

It means `ld` detected a broken in-shell recording state (for example, missing saved file descriptors). Run `ld status`, then start a new recording with `ld start`. This condition returns exit code `12`.

## How do upgrades work and can I roll back?

Run `./install.sh` again to upgrade. If your existing `~/.config/ld/ld.sh` differs from the new one, installer stores a timestamped backup at `~/.config/ld/backups/` and updates the latest-backup pointer.

To roll back to the latest backup:

```bash
~/.config/ld/install.sh --rollback
```
