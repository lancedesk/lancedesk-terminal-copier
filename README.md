# Terminal Log Copier (ld)

Friendly terminal session recorder for Linux/macOS/WSL shells (bash and zsh).

This project helps you record command output, then copy the whole log to clipboard in one command for sharing with AI tools, teammates, or bug reports.

Search keywords: terminal log copier, shell output recorder, copy terminal output, bash logger, zsh logger, cli session recorder.

## Why this project

- No more manual highlight and copy
- Works in normal shell flow
- Fast clipboard copy with `ld c`
- Auto-available in new terminal sessions after install

## Commands

- `ld start` start recording in current shell session
- `ld stop` stop recording
- `ld c` copy current/last log to clipboard
- `ld +c` alias of `ld c`
- `ld status` show recorder state
- `ld show` print current/last log

## Install

```bash
chmod +x install.sh
./install.sh
source ~/.zshrc
```

## Quick usage

```bash
ld start
python3 script.py
ld stop
ld c
```

## Where logs are stored

- Logs: `~/.local/share/ld/logs/`
- Last-log pointer: `~/.local/state/ld/current_log`

## Clipboard support

Auto-detects one of:
- `wl-copy`
- `xclip`
- `xsel`
- `pbcopy`
- `clip.exe`

## Publish to GitHub

```bash
git init
git add .
git commit -m "feat: initial terminal log copier"
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```
