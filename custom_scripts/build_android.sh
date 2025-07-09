#!/bin/bash

set -e

# Absolute path to the root of the whisper.cpp project
WHISPER_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ANDROID_PROJECT_DIR="$WHISPER_ROOT/examples/whisper.android"
LIB_MODULE_DIR="$ANDROID_PROJECT_DIR/lib"
OUTPUT_DIR="$WHISPER_ROOT/output/android/jni"

echo "==> Navigating to Android project: $ANDROID_PROJECT_DIR"
cd "$ANDROID_PROJECT_DIR"

echo "==> Building Android project with Gradle..."
./gradlew :lib:assembleDebug :lib:assembleRelease

echo "==> Returning to project root"
cd "$WHISPER_ROOT"

# Copy the generated .so files
for BUILD_TYPE in debug release; do
    SRC="$LIB_MODULE_DIR/build/intermediates/library_jni/$BUILD_TYPE/jni"
    DEST="$OUTPUT_DIR/$BUILD_TYPE"

    echo "==> Processing $BUILD_TYPE"

    if [ -d "$SRC" ]; then
        mkdir -p "$DEST"
        cp -r "$SRC"/* "$DEST/"
        echo "   ✅ Copied: $SRC → $DEST"
    else
        echo "   ⚠️  Directory not found: $SRC"
    fi
done

echo "✅ All done. The .so files are located in: $OUTPUT_DIR/{debug,release}"
