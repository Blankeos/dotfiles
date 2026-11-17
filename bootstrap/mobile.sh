#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

if has fvm && [ ! -e "$HOME/fvm/default" ]; then
  log "flutter stable (fvm)"; fvm install stable && fvm global stable || warn fvm
fi

bun_tools nativescript @snap/valdi
cargo_tools flutter_rust_bridge_codegen rinf

finish
