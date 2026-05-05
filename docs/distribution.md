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

## Signed-release installer flow

If package managers are not available, use versioned GitHub release assets and checksums:

- Publish release tarball checksums with each tag.
- Verify checksums before install in automation environments.
- Keep rollback instructions in `README.md` and `docs/faq.md`.

## APT option (future)

APT packaging is planned but not yet implemented. Until then, use:

- Homebrew tap for macOS/Linux users already on brew.
- GitHub release install flow for general Linux environments.
