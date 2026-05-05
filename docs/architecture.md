# Architecture

`ld` is a shell function loaded into bash/zsh sessions from `~/.config/ld/ld.sh`.

## Runtime model

- `ld start`:
  - Creates a timestamped log file in `~/.local/share/ld/logs/`.
  - Saves the current log path to `~/.local/state/ld/current_log`.
  - Redirects stdout/stderr through `tee` so output is both visible and persisted.
- `ld stop`:
  - Restores original stdout/stderr file descriptors.
  - Stops capture in the current shell session.
- `ld c`:
  - Copies current log (or last known log from state file) to clipboard.

## State and file locations

- Logs directory: `~/.local/share/ld/logs/`
- State directory: `~/.local/state/ld/`
- Current log pointer: `~/.local/state/ld/current_log`
- Installed scripts: `~/.config/ld/ld.sh`, `~/.config/ld/install.sh`, `~/.config/ld/uninstall.sh`
- Upgrade backups: `~/.config/ld/backups/` with latest pointer in `~/.config/ld/backups/last_backup`

## Session scope

Capture is per shell session by design. Running `ld start` in one terminal tab does not affect other tabs.

## Clipboard strategy

Clipboard support is capability-based and uses the first available tool:

1. `wl-copy`
2. `xclip`
3. `xsel`
4. `pbcopy`
5. `clip.exe`

If no tool exists, logs remain safely stored on disk and can still be opened with `ld show`.
