#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_FILE="$SCRIPT_DIR/ld.sh"
VERSION_FILE="$SCRIPT_DIR/VERSION"
DEST_DIR="$HOME/.config/ld"
DEST_FILE="$DEST_DIR/ld.sh"
INSTALL_FILE="$DEST_DIR/install.sh"
DEST_VERSION_FILE="$DEST_DIR/VERSION"
# shellcheck disable=SC2016
SOURCE_LINE='[ -f "$HOME/.config/ld/ld.sh" ] && source "$HOME/.config/ld/ld.sh"'
UNINSTALL_HINT="$DEST_DIR/uninstall.sh"
BACKUP_DIR="$DEST_DIR/backups"
LAST_BACKUP_FILE="$BACKUP_DIR/last_backup"

rollback_latest() {
  if [ ! -f "$LAST_BACKUP_FILE" ]; then
    echo "[ld] No backup metadata found at: $LAST_BACKUP_FILE"
    echo "[ld] Nothing to roll back."
    return 1
  fi

  local backup_file
  backup_file="$(cat "$LAST_BACKUP_FILE")"
  if [ -z "$backup_file" ] || [ ! -f "$backup_file" ]; then
    echo "[ld] Latest backup file is missing: $backup_file"
    return 1
  fi

  mkdir -p "$DEST_DIR"
  cp "$backup_file" "$DEST_FILE"
  chmod +x "$DEST_FILE"
  echo "[ld] Rolled back ld.sh from backup:"
  echo "  $backup_file"
  echo "[ld] Restored file:"
  echo "  $DEST_FILE"
}

if [ "${1:-}" = "--rollback" ]; then
  rollback_latest
  exit $?
fi

mkdir -p "$DEST_DIR"
mkdir -p "$BACKUP_DIR"

if [ -f "$DEST_FILE" ]; then
  if cmp -s "$SRC_FILE" "$DEST_FILE"; then
    echo "Already up to date: $DEST_FILE"
  else
    backup_file="$BACKUP_DIR/ld.sh.$(date +%Y%m%d-%H%M%S).bak"
    cp "$DEST_FILE" "$backup_file"
    printf '%s\n' "$backup_file" > "$LAST_BACKUP_FILE"
    echo "Backed up previous ld.sh: $backup_file"
    cp "$SRC_FILE" "$DEST_FILE"
    echo "Upgraded: $DEST_FILE"
  fi
else
  cp "$SRC_FILE" "$DEST_FILE"
  echo "Installed: $DEST_FILE"
fi

cp "$SCRIPT_DIR/install.sh" "$INSTALL_FILE"
cp "$SCRIPT_DIR/uninstall.sh" "$UNINSTALL_HINT"
if [ -f "$VERSION_FILE" ]; then
  cp "$VERSION_FILE" "$DEST_VERSION_FILE"
fi
chmod +x "$DEST_FILE" "$INSTALL_FILE" "$UNINSTALL_HINT"

ensure_source_line() {
  local rc_file="$1"
  touch "$rc_file"
  if ! grep -Fq "$SOURCE_LINE" "$rc_file"; then
    printf '\n# ld terminal logger\n%s\n' "$SOURCE_LINE" >> "$rc_file"
    echo "Updated: $rc_file"
  else
    echo "Already configured: $rc_file"
  fi
}

ensure_source_line "$HOME/.bashrc"
ensure_source_line "$HOME/.zshrc"

# ./install.sh runs in a child process: it cannot export functions into the parent shell.
# If this file is *sourced* in bash (source ./install.sh), we end in the same shell and can load ld here.
_ld_install_sourced_in_bash() {
  [ -n "${BASH_SOURCE[0]:-}" ] && [ "${BASH_SOURCE[0]}" != "${0}" ]
}

echo ""
echo "Installer: $INSTALL_FILE"
echo "Uninstall: $UNINSTALL_HINT"
echo "Rollback: $INSTALL_FILE --rollback"

if _ld_install_sourced_in_bash; then
  # shellcheck source=/dev/null
  source "$DEST_FILE"
  echo ""
  echo "[ld] Loaded in this shell (install was sourced). Try: ld help"
else
  echo ""
  echo "Use ld in this terminal without opening a new window:"
  echo "  source \"$DEST_FILE\""
  echo ""
  echo "New terminals pick up ld automatically via ~/.bashrc and ~/.zshrc."
fi

echo ""
echo "Usage: ld start ; <run commands> ; ld stop ; ld c"
