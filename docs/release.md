# Release Process

This project uses Semantic Versioning and a changelog-first release process.

## Versioning policy

- `MAJOR` for breaking CLI behavior changes.
- `MINOR` for backward-compatible features.
- `PATCH` for backward-compatible fixes/docs/test improvements.

## Release checklist

1. Ensure CI is green on `main`.
2. Update `VERSION`.
3. Update `CHANGELOG.md` with release date and notes.
4. Verify install/upgrade/rollback flows locally:
   - `./install.sh`
   - `~/.config/ld/install.sh --rollback` (after creating a backup)
5. Run local checks:
   - `bash -n ld.sh install.sh uninstall.sh`
   - `./tests/smoke_test.sh`
   - `./tests/clipboard_fallback_test.sh`
   - `./tests/upgrade_rollback_test.sh`
6. Commit release prep changes.
7. Create signed tag (preferred) or annotated tag fallback:
   - Preferred: `git tag -s vX.Y.Z -m "Release vX.Y.Z"`
   - Fallback: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
8. Push branch and tags:
   - `git push origin main`
   - `git push origin vX.Y.Z`
9. Build and upload release assets:
   - `./scripts/build-release-artifacts.sh X.Y.Z dist`
   - Optional signing: `gpg --armor --detach-sign dist/checksums.txt`
10. Publish GitHub Release notes using matching changelog entry.

## v0.1.0 migration notes

- First public tagged release.
- Existing users can upgrade by re-running `./install.sh`.
- If needed, roll back to previous installed `ld.sh` with:
  - `~/.config/ld/install.sh --rollback`
