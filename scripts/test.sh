#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SCHEME="${SCHEME:-SoulMateApp}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 16}"

if [[ ! -d "SoulMateApp.xcodeproj" ]]; then
  "$ROOT_DIR/scripts/bootstrap.sh"
fi

if [[ ! -d "SoulMateApp.xcodeproj" ]]; then
  echo "ERROR: SoulMateApp.xcodeproj not found."
  exit 1
fi

echo "==> Running unit tests"
xcodebuild \
  -project SoulMateApp.xcodeproj \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  test

echo "==> Tests passed"
