# Contributing

Thanks for your interest in improving LanceDesk Terminal Copier.

## Development setup

```bash
git clone https://github.com/lancedesk/lancedesk-terminal-copier.git
cd lancedesk-terminal-copier
bash -n ld.sh install.sh uninstall.sh
./tests/smoke_test.sh
./tests/clipboard_fallback_test.sh
./tests/upgrade_rollback_test.sh
```

## Contribution guidelines

- Keep CLI behavior backward compatible where possible.
- Add or update tests for behavior changes.
- Keep shell code compatible with bash and zsh usage expectations.
- Update docs when user-visible behavior changes.

## Pull request checklist

- [ ] Code and docs updated.
- [ ] Local checks/tests pass.
- [ ] Changelog entry added for notable user-facing changes.
- [ ] PR description explains user impact and migration notes (if any).

## Code style

- Prefer clear shell functions with explicit error handling.
- Keep messages concise and automation-friendly.
- Use `shellcheck` clean patterns.
