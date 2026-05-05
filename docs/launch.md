# Launch Kit

This file provides ready-to-use launch content for `v0.1.0`.

## Announcement post template

```text
We just released LanceDesk Terminal Copier (`ld`) - a tiny CLI that records terminal output and copies full session logs in one command.

Why we built it:
- manual highlight/copy is fragile for long sessions
- bug reports need exact command + output history
- AI debugging workflows work better with full logs

Quick flow:
ld start
# run commands
ld stop
ld c

Repo: https://github.com/lancedesk/lancedesk-terminal-copier
Docs: README + docs/team-examples.md

Feedback welcome - tell us your real workflow and we will prioritize roadmap items.
```

## 60-second tutorial script (video/GIF voiceover)

1. Open terminal and run install command.
2. Show `ld help` and `ld version`.
3. Run `ld start`, execute a noisy script/test command.
4. Run `ld stop` and `ld c`.
5. Paste into issue template / AI prompt template.
6. Show where logs are stored and rollback command.

## Submission checklist (tool directories/newsletters)

- [ ] GitHub release created and tagged (`v0.1.0`).
- [ ] README includes badges, quick start, and docs links.
- [ ] Add project to CLI/tool directories (for example: Awesome CLI lists, command line tool collections).
- [ ] Share launch post on X/LinkedIn/Reddit/dev communities.
- [ ] Send short pitch to developer newsletters.
- [ ] Collect first 3 external testimonials and link in README.
