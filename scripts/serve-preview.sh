#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${PORT:-4173}"
cd "$ROOT_DIR/web-preview"

echo "==> Soul Mate UI Preview"
echo "    http://localhost:${PORT}"
echo "    Press Ctrl+C to stop"

if command -v python3 >/dev/null 2>&1; then
  exec python3 -m http.server "$PORT"
elif command -v python >/dev/null 2>&1; then
  exec python -m SimpleHTTPServer "$PORT"
else
  echo "ERROR: Python not found"
  exit 1
fi
