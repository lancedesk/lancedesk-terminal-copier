#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version-without-v-prefix> [install-dir]"
  echo "Example: $0 0.1.0"
  exit 1
fi

version="$1"
install_dir="${2:-$HOME/.config/ld}"
tag="v${version}"
base_url="https://github.com/lancedesk/lancedesk-terminal-copier/releases/download/${tag}"
archive_name="lancedesk-terminal-copier-${tag}.tar.gz"
checksums_name="checksums.txt"
sig_name="checksums.txt.asc"

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

archive_path="$tmp_dir/$archive_name"
checksums_path="$tmp_dir/$checksums_name"
sig_path="$tmp_dir/$sig_name"

echo "Downloading release assets for ${tag}..."
curl -fsSL "${base_url}/${archive_name}" -o "$archive_path"
curl -fsSL "${base_url}/${checksums_name}" -o "$checksums_path"

echo "Verifying checksum..."
expected="$(awk -v file="$archive_name" '$2 == file { print $1 }' "$checksums_path")"
if [ -z "$expected" ]; then
  echo "Could not find checksum entry for ${archive_name}"
  exit 1
fi
actual="$(sha256sum "$archive_path" | awk '{print $1}')"
if [ "$expected" != "$actual" ]; then
  echo "Checksum mismatch for ${archive_name}"
  echo "Expected: $expected"
  echo "Actual:   $actual"
  exit 1
fi

echo "Checksum verified."

if curl -fsSL "${base_url}/${sig_name}" -o "$sig_path"; then
  if command -v gpg >/dev/null 2>&1; then
    echo "Signature file found. Verifying checksums signature with gpg..."
    gpg --verify "$sig_path" "$checksums_path"
    echo "Signature verified."
  else
    echo "Signature file found but gpg is unavailable. Skipping signature verification."
  fi
else
  echo "No signature file found for checksums. Proceeding with checksum verification only."
fi

echo "Extracting and installing to ${install_dir}..."
mkdir -p "$install_dir"
tar -xzf "$archive_path" -C "$tmp_dir"
src_dir="$tmp_dir/lancedesk-terminal-copier-${version}"

cp "$src_dir/ld.sh" "$install_dir/ld.sh"
cp "$src_dir/install.sh" "$install_dir/install.sh"
cp "$src_dir/uninstall.sh" "$install_dir/uninstall.sh"
cp "$src_dir/VERSION" "$install_dir/VERSION"
chmod +x "$install_dir/ld.sh" "$install_dir/install.sh" "$install_dir/uninstall.sh"

echo "Installed release ${tag}."
echo "Load in current shell:"
echo "  source \"$install_dir/ld.sh\""
