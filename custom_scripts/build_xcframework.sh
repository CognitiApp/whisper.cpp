#!/usr/bin/env bash
set -e

# Run the main build script located at project root
bash "$(dirname "$0")/../build-xcframework.sh"

# Copy the result to output/apple/
FINAL_OUTPUT_DIR="$(pwd)/output/apple"
mkdir -p "$FINAL_OUTPUT_DIR"

echo "📦 Copying whisper.xcframework to $FINAL_OUTPUT_DIR..."
cp -R "$(pwd)/build-apple/whisper.xcframework" "$FINAL_OUTPUT_DIR/"

echo "✅ whisper.xcframework has been copied to: $FINAL_OUTPUT_DIR"