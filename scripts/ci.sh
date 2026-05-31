#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "======================================"
echo " Soul Mate CI Pipeline (local)"
echo "======================================"

"$ROOT_DIR/scripts/bootstrap.sh"
"$ROOT_DIR/scripts/lint.sh"

if xcode-select -p 2>/dev/null | grep -q "Xcode.app"; then
  "$ROOT_DIR/scripts/build.sh"
  "$ROOT_DIR/scripts/test.sh"
else
  echo "Skipping build/test: full Xcode not configured."
fi

echo "======================================"
echo " CI pipeline complete"
echo "======================================"
