#!/usr/bin/env bash
# Build a production APK (release mode, obfuscated, split debug symbols).
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Flutter clean (optional: pass --no-clean to skip)"
if [[ "${1:-}" != "--no-clean" ]]; then
  flutter clean
  flutter pub get
fi

SYMBOLS_DIR="build/app/outputs/symbols"
mkdir -p "$SYMBOLS_DIR"

echo "==> Building release APK..."
flutter build apk --release \
  --obfuscate \
  --split-debug-info="$SYMBOLS_DIR"

APK="build/app/outputs/flutter-apk/app-release.apk"
if [[ -f "$APK" ]]; then
  echo ""
  echo "Release APK ready:"
  echo "  $APK"
  ls -lh "$APK"
else
  echo "Build finished; check build/app/outputs/flutter-apk/"
fi
