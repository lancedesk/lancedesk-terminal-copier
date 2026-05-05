class LancedeskTerminalCopier < Formula
  desc "Record terminal output and copy full session logs quickly"
  homepage "https://github.com/lancedesk/lancedesk-terminal-copier"
  url "https://github.com/lancedesk/lancedesk-terminal-copier/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_RELEASE_TARBALL_SHA256"
  license "MIT"

  def install
    libexec.install "ld.sh", "install.sh", "uninstall.sh", "VERSION"

    (bin/"ld-install").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      exec "#{libexec}/install.sh" "$@"
    EOS
    chmod 0755, bin/"ld-install"
  end

  def caveats
    <<~EOS
      Run this after installation:
        ld-install

      Then load ld in your current shell:
        source ~/.config/ld/ld.sh
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ld-install --help 2>&1", 0)
  end
end
