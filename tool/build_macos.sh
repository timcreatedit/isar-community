#!/bin/bash


# Use a host-compatible toolchain. GitHub's macos-14 label may resolve to
# either Intel or Apple Silicon runners, while both targets are cross-compiled
# below to produce the universal library.
case "$(uname -m)" in
  arm64) RUST_TOOLCHAIN="1.88.0-aarch64-apple-darwin" ;;
  x86_64) RUST_TOOLCHAIN="1.88.0-x86_64-apple-darwin" ;;
  *) echo "Unsupported macOS architecture: $(uname -m)" >&2; exit 1 ;;
esac

# Instalar a toolchain se não existir
rustup toolchain install $RUST_TOOLCHAIN

echo "Building for macOS"
rustup run $RUST_TOOLCHAIN rustc --version
rustup run $RUST_TOOLCHAIN cargo --version
rustup target add aarch64-apple-darwin x86_64-apple-darwin --toolchain $RUST_TOOLCHAIN
rustup run $RUST_TOOLCHAIN cargo build --target aarch64-apple-darwin --release
rustup run $RUST_TOOLCHAIN cargo build --target x86_64-apple-darwin --release
lipo "target/aarch64-apple-darwin/release/libisar.dylib" "target/x86_64-apple-darwin/release/libisar.dylib" -output "libisar_macos.dylib" -create
install_name_tool -id @rpath/libisar.dylib libisar_macos.dylib
