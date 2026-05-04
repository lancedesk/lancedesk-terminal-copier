# Terminal Log Copier (ld)

Copy terminal output to clipboard fast. `ld` is a lightweight terminal log recorder, shell output copier, and CLI session recorder for bash and zsh on Linux, macOS, and WSL.

Use it when you want to capture command output, save a full terminal session log, and paste the result into AI tools, issue reports, or chat messages with one command.

## Why this project

- No more manual highlight and copy
- Works in normal shell flow
- Fast clipboard copy with `ld c`
- Auto-available in new terminal sessions after install

## Best for

- Copying terminal output into ChatGPT, Claude, or other AI tools
- Sharing bug reports with full command logs
- Keeping a clean record of script output during debugging
- Bash and zsh users who want a quick clipboard workflow

## Commands

- `ld start` start recording in current shell session
- `ld stop` stop recording
- `ld c` copy current/last log to clipboard
- `ld +c` alias of `ld c`
- `ld status` show recorder state
- `ld show` print current/last log

## Install

```bash
git clone https://github.com/lancedesk/terminal-log-copier.git
cd terminal-log-copier
chmod +x install.sh
./install.sh
```

Reload your current shell:

```bash
# zsh
source ~/.zshrc

# bash
source ~/.bashrc
```

Verify:

```bash
ld help
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

