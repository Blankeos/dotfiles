#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# --- self-installing toolchains (they update themselves; see scripts/mprocs.yaml)
has rustup || { log "rustup"; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || warn rustup; }
# SHELL=sh: stops the bun installer from appending to the stowed ~/.zshrc (it already has bun)
has bun || { log "bun"; curl -fsSL https://bun.sh/install | SHELL=/bin/sh bash || warn bun; }
has uv || { log "uv"; curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh || warn uv; }
has claude || { log "claude"; curl -fsSL https://claude.ai/install.sh | bash || warn claude; }
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if has fnm && ! fnm list | grep -q 'v[0-9]'; then
  log "node lts (fnm)"; fnm install --lts && fnm default lts-latest || warn fnm
fi

# --- my tools + globals (rerun on --update = upgrade)
log "cargo tools"
cargo_tools \
  crabcode crabenv lazygitrs iconmate devrefs cftun uplate \
  cargo-dist cargo-expand cargo-generate cargo-zigbuild \
  trunk wasm-pack wasm-bindgen-cli diesel_cli sea-orm-cli dioxus-cli protoc-gen-prost rust-to-npm-cli
# niche, install by hand when needed: tuono cargo-fframes rustlings bevy_cli(git) helix(local) zed-theme-tokens sql-gen

log "go tools"
go_tools \
  golang.org/x/tools/gopls \
  mvdan.cc/gofumpt \
  honnef.co/go/tools/cmd/staticcheck \
  github.com/pressly/goose/v3/cmd/goose \
  github.com/wailsapp/wails/v2/cmd/wails \
  github.com/Blankeos/herdr-serve/cmd/herdr-serve

log "bun globals"
bun_tools \
  +agent-browser +agent-desktop \
  @blankeos/modelcli @google/gemini-cli @typescript/native-preview typescript-language-server \
  gittydocs opkg ralphy-cli reyes-cli

log "npm globals"
npm_tools pnpm @rynfar/meridian @vercel/before-and-after portless

# --- agent config (needs stow done)
has skillshare && { log "skillshare sync"; skillshare sync || warn skillshare; }
if has bun; then
  log "mcp-sync"
  (cd "$DOTFILES/scripts/mcp-sync" && bun install --silent) && mcp-sync --write || warn "mcp-sync"
fi

finish
