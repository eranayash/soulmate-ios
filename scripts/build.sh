#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SCHEME="${SCHEME:-SoulMateApp}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 16}"

if [[ ! -d "SoulMateApp.xcodeproj" ]]; then
  echo "Xcode project missing. Running bootstrap..."
  "$ROOT_DIR/scripts/bootstrap.sh"
fi

if [[ ! -d "SoulMateApp.xcodeproj" ]]; then
  echo "ERROR: SoulMateApp.xcodeproj not found. Install xcodegen and re-run bootstrap."
  exit 1
fi

echo "==> Building $SCHEME for $DESTINATION"
xcodebuild \
  -project SoulMateApp.xcodeproj \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  build

echo "==> Build succeeded"
