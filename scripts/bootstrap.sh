#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Soul Mate bootstrap"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen not found. Install with: brew install xcodegen"
  echo "Continuing without generating Xcode project..."
else
  echo "==> Generating Xcode project"
  xcodegen generate
fi

if ! xcode-select -p 2>/dev/null | grep -q "Xcode.app"; then
  echo ""
  echo "WARNING: Full Xcode is not selected."
  echo "Run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
  echo "Build/test scripts require Xcode (not Command Line Tools only)."
fi

echo "==> Bootstrap complete"
echo "Open SoulMateApp.xcodeproj in Xcode, or run: ./scripts/build.sh"
