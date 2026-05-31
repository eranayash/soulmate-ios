#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Lint / structure checks"

required_dirs=(
  "SoulMateApp/App"
  "SoulMateApp/Core"
  "SoulMateApp/Features"
  "SoulMateApp/Services"
  "SoulMateApp/Models"
  "SoulMateAppTests"
  "scripts"
  ".github/workflows"
)

for dir in "${required_dirs[@]}"; do
  if [[ ! -d "$dir" ]]; then
    echo "FAIL: missing directory $dir"
    exit 1
  fi
done

required_files=(
  "SoulMateApp/App/SoulMateApp.swift"
  "SoulMateApp/Services/TokenEconomyService.swift"
  "SoulMateApp/Features/Chat/Views/ChatRoomView.swift"
  "project.yml"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "FAIL: missing file $file"
    exit 1
  fi
done

if command -v swift >/dev/null 2>&1; then
  echo "==> Swift syntax parse (best effort)"
  while IFS= read -r -d '' file; do
    if ! swift -frontend -parse "$file" >/dev/null 2>&1; then
      echo "WARN: parse check failed for $file (may require Xcode SDK)"
    fi
  done < <(find SoulMateApp SoulMateAppTests -name '*.swift' -print0)
fi

echo "==> Lint checks passed"
