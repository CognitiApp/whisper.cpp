# Whisper.cpp Build Scripts

This repository contains custom build scripts to compile [whisper.cpp](https://github.com/ggerganov/whisper.cpp) for the following platforms:

- Android (.so)
- iOS, macOS, visionOS, tvOS (.xcframework)
- WebAssembly (.wasm, .js)

All outputs are placed under `output/` by default.

## Requirements

### General
- Git
- Bash shell

### Android
- Java 17 (recommended)
- Android Studio + Android SDK
- gradle (or use the Gradle wrapper provided)

### iOS / macOS / visionOS / tvOS
- macOS with Apple Silicon or Intel
- Xcode 15.0+ with command line tools (`xcode-select --install`)
- CMake 3.28+ (via `brew install cmake`)
- libtool (included with CLT)
- dsymutil (included with Xcode)

### WebAssembly (WASM) Build Setup

To build the project for WebAssembly, you need to install and set up the **Emscripten SDK (emsdk)**, which provides the `emcc` compiler and related tools.

#### Installing Emscripten SDK

1. Clone the Emscripten SDK repository:

```bash
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
````

2. Install and activate the latest version of Emscripten:

```bash
./emsdk install latest
./emsdk activate latest
```

3. Define EMSDK_ROOT variable 

```bash
export EMSDK_ROOT=/Users/$USER/emsdk
export PATH=$PATH:$EMSDK_ROOT
```

## Build Outputs

Platform   | Output Directory                     | Artifact
-----------|--------------------------------------|------------------------------
Android    | output/android/jni/{debug,release}/  | libwhisper.so
iOS/macOS  | build-apple/                         | whisper.xcframework
Web        | output/wasm/                         | whisper.wasm, whisper.js

## How to Build

### Android

Builds both `debug` and `release` `.so` files using the example Gradle project:

    bash custom_scripts/build_android.sh

Output will be in:

    output/android/jni/{debug,release}/

### iOS, macOS, visionOS, tvOS

Builds all Apple targets and generates an `xcframework`:

    bash custom_scripts/build_xcframework.sh

Output will be in:

    build-apple/whisper.xcframework

### WebAssembly

Compiles `whisper.cpp` to WebAssembly using Emscripten:

    bash custom_scripts/build_wasm.sh

Output will be in:

    output/wasm/whisper.wasm
    output/wasm/whisper.js

Make sure Emscripten is activated:

    source /path/to/emsdk/emsdk_env.sh

## Integration

These artifacts are intended to be used as native backends in a Flutter plugin using `dart:ffi` for Android and iOS/macOS, and `package:wasm` for Web.

## Cleaning

Each script removes previous builds automatically. To clean manually:

    rm -rf output/
    rm -rf build-*

## Maintainer Notes

- Apple targets include CoreML (`libwhisper.coreml.a`)
- iOS and tvOS builds contain both simulator and device slices
- Debug symbols (`.dSYM`) are included in the `xcframework`
- You can adjust `EXPORTED_FUNCTIONS` in the WebAssembly script to control which C functions are accessible
