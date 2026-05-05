from __future__ import annotations

import os
import subprocess
import sys
import tempfile
import urllib.request


def main() -> int:
    version = sys.argv[1] if len(sys.argv) > 1 else "0.1.0"
    script_url = (
        "https://raw.githubusercontent.com/"
        "lancedesk/lancedesk-terminal-copier/main/scripts/install-release.sh"
    )

    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        tmp_path = tmp.name

    try:
        urllib.request.urlretrieve(script_url, tmp_path)
        os.chmod(tmp_path, 0o755)
        return subprocess.call([tmp_path, version])
    finally:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)


if __name__ == "__main__":
    raise SystemExit(main())
