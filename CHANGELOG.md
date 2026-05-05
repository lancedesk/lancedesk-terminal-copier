# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-05-05

### Added

- Core CLI workflow: `ld start`, `ld stop`, `ld c`, `ld show`, `ld status`, `ld help`.
- Clipboard auto-detection for `wl-copy`, `xclip`, `xsel`, `pbcopy`, `clip.exe`.
- Installer and uninstaller scripts with shell rc setup.
- Idempotent upgrade path with automatic backup creation.
- Rollback command via `~/.config/ld/install.sh --rollback`.
- CI workflow for shell syntax checks, shellcheck, and integration tests.
- Integration tests:
  - smoke workflow test (`start -> stop -> c`)
  - clipboard fallback behavior
  - upgrade/rollback behavior
- Documentation set (`README`, architecture/security/faq/roadmap docs).
- Version metadata file (`VERSION`) and `ld version` command.

### Notes

- Initial public release focused on reliable per-session terminal capture and copy.
- No migration steps required for first-time install.
