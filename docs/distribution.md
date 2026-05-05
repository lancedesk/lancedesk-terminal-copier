# Distribution Guide

This guide covers practical distribution channels for `ld`.

## Homebrew tap (macOS/Linux)

`ld` uses shell files and post-install setup in user shell config, so the recommended Homebrew flow is:

1. Publish GitHub release tag (for example `v0.1.0`).
2. Update formula in this repo:
   - `./scripts/prepare-homebrew-formula.sh 0.1.0`
3. Copy formula to your tap repository (`homebrew-tap`), for example:
   - `Formula/lancedesk-terminal-copier.rb`
4. In tap repo, commit and push formula update.
5. Users install with:
   - `brew tap lancedesk/tap`
   - `brew install lancedesk-terminal-copier`
   - `ld-install`
   - `source ~/.config/ld/ld.sh`

## APT package option or signed installer flow

APT repository packaging is optional and can come later. A signed release installer path is implemented now.

Installer script:

- `./scripts/install-release.sh <version>`

Artifact builder:

- `./scripts/build-release-artifacts.sh <version>`

Release asset pattern:

- `lancedesk-terminal-copier-vX.Y.Z.tar.gz`
- `checksums.txt`
- `checksums.txt.asc` (optional but recommended)

When `checksums.txt.asc` is present and `gpg` is installed, the installer verifies signature before install.

## Signed-release installer flow

If package managers are not available, use versioned GitHub release assets and checksums/signatures:

- Publish release tarball checksums with each tag.
- Sign `checksums.txt` with `gpg --armor --detach-sign`.
- Verify checksums and signature before install in automation environments.
- Keep rollback instructions in `README.md` and `docs/faq.md`.

## npm/pip wrappers (discoverability)

Wrapper scaffolding is included for distribution channels where users discover tools via language package indexes:

- npm wrapper: `wrappers/npm/`
- pip wrapper: `wrappers/pip/`

Both wrappers call the same release installer flow.
