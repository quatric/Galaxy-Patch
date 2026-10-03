#!/bin/zsh
# Build the standalone GUI patcher app with PyInstaller.
# Output: tools/dist/Galaxy-Patcher.app (macOS) or dist/Galaxy-Patcher/ (other OSes).
# `wit` is not bundled here -- put it on PATH, or use the CI workflow, which bundles it.
set -eu
cd "${0:a:h}"
command -v pyinstaller >/dev/null || { echo "pyinstaller not found (pip install pyinstaller tkinterdnd2)"; exit 1; }
pyinstaller --noconfirm Galaxy-Patcher.spec
echo "built: tools/dist/Galaxy-Patcher"
