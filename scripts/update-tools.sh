#!/usr/bin/env bash

# Update all tools in parallel with a TUI.
# To add more, just add a new line below.
mprocs \
  "uv self update" \
  "brew upgrade sst/tap/opencode" \
  "rustup upgrade" \
  "bun upgrade" \
  "claude upgrade" \
  "brew upgrade lazygit"
