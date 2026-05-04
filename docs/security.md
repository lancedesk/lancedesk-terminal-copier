# Security and Privacy

`ld` records terminal output for the current shell session when active.

## What gets logged

- Standard output and standard error emitted while recording is enabled.
- Any secrets echoed to terminal during recording (tokens, keys, credentials) can be captured.

## What does not happen

- No network transmission or remote upload is performed by default.
- No background daemon runs outside your shell sessions.

## Safe usage guidelines

- Start recording only for relevant command windows.
- Stop recording immediately after collecting needed output.
- Review logs before sharing externally.
- Avoid recording sessions that print secrets.

## Recommended hardening (future)

- Add optional redaction patterns for known secret formats.
- Add a "private mode" warning before copy/share actions.
- Add configurable log retention and cleanup automation.
