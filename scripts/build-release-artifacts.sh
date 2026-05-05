#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version-without-v-prefix> [output-dir]"
  echo "Example: $0 0.1.0 dist"
  exit 1
fi

version="$1"
out_dir="${2:-dist}"
tag="v${version}"
archive_name="lancedesk-terminal-copier-${tag}.tar.gz"
checksums_name="checksums.txt"

mkdir -p "$out_dir"

echo "Building archive ${archive_name} from tag ${tag}..."
git archive --format=tar.gz --prefix="lancedesk-terminal-copier-${version}/" -o "${out_dir}/${archive_name}" "${tag}"

echo "Generating checksums..."
(
  cd "$out_dir"
  sha256sum "$archive_name" > "$checksums_name"
)

echo "Artifacts ready in ${out_dir}:"
echo "  ${archive_name}"
echo "  ${checksums_name}"
echo ""
echo "Optional signing:"
echo "  gpg --armor --detach-sign \"${out_dir}/${checksums_name}\""
