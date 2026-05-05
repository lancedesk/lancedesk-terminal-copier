# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-05-05

### Added

- GitHub Pages one-page landing site in `docs/` with branding, docs links, and favicon.
- Brand assets (`assets/logo-mark.svg`, `assets/readme-banner.svg`) and updated README presentation.
- New `ld c` default behavior that sanitizes terminal control sequences for cleaner sharing.
- `ld c --raw` for exact raw-byte copies and `ld show --clean` for sanitized terminal display.
- New sanitize integration test (`tests/sanitize_copy_test.sh`) added to CI.
- Release/distribution scaffolding:
  - release artifact builder (`scripts/build-release-artifacts.sh`)
  - signed/checksummed installer flow (`scripts/install-release.sh`)
  - npm/pip discoverability wrapper scaffolds.

### Changed

- Runtime safety improvements for interrupted sessions and stale descriptor recovery.
- CI workflow modernization and stabilization:
  - `actions/checkout@v5`
  - deterministic clipboard fallback test behavior
  - rollback test invocation hardened across runners.

### Notes

- This release is backward-compatible with existing installs.
- Recommended upgrade path: `git pull && ./install.sh && source ~/.config/ld/ld.sh`.
- Signed tag publication remains optional where a local GPG key is unavailable.

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
