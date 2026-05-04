# LanceDesk Terminal Copier (`ld`)

Record terminal output and copy full session logs in one command.

`ld` is a lightweight terminal logger for bash/zsh on Linux, macOS, and WSL. It keeps your normal shell flow and removes manual highlight-copy for long outputs.

## 60-second quick start

```bash
git clone https://github.com/lancedesk/lancedesk-terminal-copier.git
cd lancedesk-terminal-copier
chmod +x install.sh
./install.sh
source ~/.bashrc   # or source ~/.zshrc
```

Verify:

```bash
ld help
```

## Basic workflow

```bash
ld start
# run scripts, builds, tests, or any commands
ld stop
ld c
```

Now paste with `Ctrl+V` into issue reports, chats, or AI tools.

## Commands

- `ld start` - start recording in current shell session
- `ld stop` - stop recording
- `ld c` - copy current/last log to clipboard
- `ld +c` - alias of `ld c`
- `ld status` - show recorder state
- `ld show` - print current/last log
- `ld help` - show command help

## Why not just redirect output to a file?

You can use `>> file.log`, but that is manual and less reusable in day-to-day troubleshooting. `ld` adds:

- one command to start capture
- one command to copy full logs
- automatic "last log" tracking
- per-session control with zero daemon overhead

## Where logs are stored

- Logs: `~/.local/share/ld/logs/`
- Last log pointer: `~/.local/state/ld/current_log`

## Clipboard support

`ld` auto-detects:

- `wl-copy`
- `xclip`
- `xsel`
- `pbcopy`
- `clip.exe`

If no clipboard tool is available, logs are still saved and can be viewed with `ld show`.

## Uninstall

```bash
~/.config/ld/uninstall.sh
```

## Documentation

- `docs/architecture.md` - runtime model and internals
- `docs/security.md` - privacy and safe-usage guidance
- `docs/faq.md` - troubleshooting and common questions
- `docs/roadmap.md` - public roadmap

## License

MIT

