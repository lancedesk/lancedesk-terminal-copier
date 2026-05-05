#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <version-without-v-prefix>"
  echo "Example: $0 0.1.0"
  exit 1
fi

version="$1"
tag="v${version}"
url="https://github.com/lancedesk/lancedesk-terminal-copier/archive/refs/tags/${tag}.tar.gz"

tmp_file="$(mktemp)"
cleanup() {
  rm -f "$tmp_file"
}
trap cleanup EXIT

echo "Downloading release tarball: $url"
curl -fsSL "$url" -o "$tmp_file"
sha="$(sha256sum "$tmp_file" | awk '{print $1}')"

formula_path="packaging/homebrew/lancedesk-terminal-copier.rb"
if [ ! -f "$formula_path" ]; then
  echo "Formula file not found: $formula_path"
  exit 1
fi

sed -i "s|url \".*\"|url \"$url\"|" "$formula_path"
sed -i "s|sha256 \".*\"|sha256 \"$sha\"|" "$formula_path"

echo "Updated formula:"
echo "  $formula_path"
echo "  version: $version"
echo "  sha256:  $sha"
