# FAQ

## Why not just use `>> file.log`?

Redirection is useful but manual. `ld` keeps your normal terminal workflow and gives one-command clipboard copy (`ld c`) after recording.

## Does this log all terminal tabs automatically?

No. Logging is session-scoped. You choose where to capture by running `ld start` in that shell.

## What if `ld c` says no clipboard tool found?

Install one of the supported tools (`wl-copy`, `xclip`, `xsel`, `pbcopy`, `clip.exe`) and retry. Your log file still exists and can be viewed with `ld show`.

## Where is my latest log stored?

The path is tracked in `~/.local/state/ld/current_log`. Use `ld status` or `ld show`.

## How do I uninstall?

Run:

```bash
~/.config/ld/uninstall.sh
```

Then open a new terminal.
