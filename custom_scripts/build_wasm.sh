#!/usr/bin/env bash

set -e

# ------------------ CONFIG ------------------
ROOT_DIR="$(pwd)"  # Must run from project root (whisper.cpp/)
BUILD_DIR="$ROOT_DIR/output/wasm"
OUTPUT_NAME="whisper"

WHISPER_CPP="$ROOT_DIR/src/whisper.cpp"

GGML_CORE_FILES=(
  "$ROOT_DIR/ggml/src/ggml.c"
  "$ROOT_DIR/ggml/src/ggml.cpp"
  "$ROOT_DIR/ggml/src/ggml-alloc.c"
  "$ROOT_DIR/ggml/src/ggml-opt.cpp"
  "$ROOT_DIR/ggml/src/ggml-threading.cpp"
  "$ROOT_DIR/ggml/src/ggml-backend.cpp"
  "$ROOT_DIR/ggml/src/ggml-backend-reg.cpp"
  "$ROOT_DIR/ggml/src/ggml-quants.c"
)

GGML_CPU_FILES=(
  "$ROOT_DIR/ggml/src/ggml-cpu/ggml-cpu.c"
  "$ROOT_DIR/ggml/src/ggml-cpu/vec.cpp"
  "$ROOT_DIR/ggml/src/ggml-cpu/unary-ops.cpp"
  "$ROOT_DIR/ggml/src/ggml-cpu/binary-ops.cpp"
  "$ROOT_DIR/ggml/src/ggml-cpu/quants.c"
  "$ROOT_DIR/ggml/src/ggml-cpu/repack.cpp"
  "$ROOT_DIR/ggml/src/ggml-cpu/ops.cpp"
  "$ROOT_DIR/ggml/src/ggml-cpu/traits.cpp"
)

ALL_SOURCES=("$WHISPER_CPP" "${GGML_CORE_FILES[@]}" "${GGML_CPU_FILES[@]}")
# --------------------------------------------

# Check EMSDK presence
if [ -z "$EMSDK_ROOT" ]; then
  echo "❌ ERROR: EMSDK_ROOT is not set. Please set it to your emsdk path."
  exit 1
fi

echo "✅ EMSDK_ROOT is set to: $EMSDK_ROOT"
source "$EMSDK_ROOT/emsdk_env.sh"

# Ensure output directory exists
mkdir -p "$BUILD_DIR"

echo "🚧 Building Whisper WASM module..."
for src in "${ALL_SOURCES[@]}"; do
  echo "   - $src"
done

# Compile to WASM using emcc
emcc \
  "${ALL_SOURCES[@]}" \
  -O3 \
  -I"$ROOT_DIR/include" \
  -I"$ROOT_DIR/ggml/include" \
  -I"$ROOT_DIR/ggml/src" \
  -s WASM=1 \
  -s MODULARIZE=1 \
  -s EXPORT_NAME="WhisperModule" \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s ENVIRONMENT=web \
  -s EXPORTED_FUNCTIONS="['_whisper_init_from_file', '_whisper_full']" \
  -s EXPORTED_RUNTIME_METHODS="['ccall', 'cwrap']" \
  -o "$BUILD_DIR/$OUTPUT_NAME.js"

echo ""
echo "✅ Build completed successfully!"
echo "📦 Output files:"
ls -lh "$BUILD_DIR/$OUTPUT_NAME."*