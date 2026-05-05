# LanceDesk Terminal Copier (`ld`)

[![CI](https://github.com/lancedesk/lancedesk-terminal-copier/actions/workflows/ci.yml/badge.svg)](https://github.com/lancedesk/lancedesk-terminal-copier/actions/workflows/ci.yml)

Record terminal output and copy full session logs in one command.

**LanceDesk Terminal Copier** is a small shell tool for **bash** and **zsh** on Linux, macOS, and WSL. Start recording in a terminal tab, run builds, tests, or scripts, then copy **everything that scrolled by** to the clipboard—ideal for bug reports, incident notes, and pasting into AI assistants—without manually selecting text.

## Who it is for

- Developers and operators who need **verbatim session output**, not a partial screen grab.
- Anyone filing issues who wants **commands + stdout/stderr** in one paste.
- Teams that share **repro steps** from real terminals instead of cleaned-up snippets.

## 60-second quick start

`install.sh` edits `~/.bashrc` and `~/.zshrc` so **new terminals** load `ld` automatically.  
Running `./install.sh` alone cannot define shell functions in your **current** shell—that is how Unix subprocesses work—so use **one** of the following.

**Recommended (works in bash and zsh): install, then load `ld` in this session**

```bash
git clone https://github.com/lancedesk/lancedesk-terminal-copier.git
cd lancedesk-terminal-copier
chmod +x install.sh
./install.sh && source ~/.config/ld/ld.sh
```

**Bash only — install and load in one step** (run install in the current shell)

```bash
chmod +x install.sh
source ./install.sh
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
- `ld version` - show installed version
- `ld help` - show command help

## Exit codes (automation-friendly)

- `10` - already recording
- `11` - stop requested while idle
- `12` - recorder state is inconsistent
- `20` - no log available to copy
- `21` - no supported clipboard utility found
- `22` - no log available to show

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

## Upgrade and rollback

Re-running install is idempotent and safe:

```bash
./install.sh
```

If an existing `~/.config/ld/ld.sh` differs, installer creates a timestamped backup in
`~/.config/ld/backups/` and records the latest backup pointer.

Rollback to the latest backup:

```bash
~/.config/ld/install.sh --rollback
```

## Documentation

- `docs/architecture.md` - runtime model and internals
- `docs/security.md` - privacy and safe-usage guidance
- `docs/faq.md` - troubleshooting and common questions
- `docs/roadmap.md` - public roadmap
- `docs/release.md` - semantic versioning and release checklist
- `docs/team-examples.md` - incident/bug/AI templates for teams

## Project policies

- `SECURITY.md` - vulnerability disclosure and response targets
- `CONTRIBUTING.md` - contribution workflow and quality checklist
- `CODE_OF_CONDUCT.md` - expected community behavior
- `SUPPORT.md` - support model and sponsored support direction

## Testing

```bash
./tests/smoke_test.sh
./tests/clipboard_fallback_test.sh
./tests/upgrade_rollback_test.sh
```

## License

MIT

