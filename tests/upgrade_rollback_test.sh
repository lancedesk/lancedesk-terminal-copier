#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TEST_HOME="$(mktemp -d)"

cleanup() {
  rm -rf "$TEST_HOME"
}
trap cleanup EXIT

export HOME="$TEST_HOME"

mkdir -p "$HOME/.config/ld"
cat > "$HOME/.config/ld/ld.sh" <<'EOF'
#!/usr/bin/env bash
ld() { echo "OLD_VERSION_MARKER"; }
EOF
chmod +x "$HOME/.config/ld/ld.sh"

"$PROJECT_ROOT/install.sh"

last_backup_file="$HOME/.config/ld/backups/last_backup"
if [ ! -f "$last_backup_file" ]; then
  echo "expected last backup metadata file to exist"
  exit 1
fi

backup_path="$(cat "$last_backup_file")"
if [ ! -f "$backup_path" ]; then
  echo "expected backup file to exist: $backup_path"
  exit 1
fi

if ! grep -q "OLD_VERSION_MARKER" "$backup_path"; then
  echo "expected backup to contain previous ld.sh content"
  exit 1
fi

# Simulate a broken/undesired upgraded file and verify rollback restores backup.
cat > "$HOME/.config/ld/ld.sh" <<'EOF'
#!/usr/bin/env bash
ld() { echo "BROKEN_VERSION_MARKER"; }
EOF

"$HOME/.config/ld/install.sh" --rollback

if ! grep -q "OLD_VERSION_MARKER" "$HOME/.config/ld/ld.sh"; then
  echo "rollback did not restore the previous version"
  exit 1
fi

echo "upgrade rollback test passed"
