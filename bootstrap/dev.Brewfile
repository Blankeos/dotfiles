# dev: languages, CLIs, agent tooling. Enough for a headless agent machine.
# Non-brew tools (rustup, bun, uv, cargo/go/bun globals) are in dev.sh.

tap "anomalyco/tap", "https://github.com/anomalyco/homebrew-tap.git", trusted: { formulae: ["opencode"] }
tap "blankeos/tap"
tap "jnsahaj/lumen"
tap "kitlangton/tap"
tap "leepokai/codync"
tap "omsimos/tap"
tap "posthog/tap"
tap "schpet/tap"
tap "steipete/tap"

# languages / runtimes
brew "go"
brew "gleam"
brew "odin"
brew "zig"
brew "fnm"
brew "node"
brew "python@3.12"
brew "python@3.11"
brew "xz"
brew "cmake"
brew "bazelisk"
brew "cargo-binstall"

# build / libs
brew "gtk4"
brew "libpq"
brew "poppler"
brew "tesseract"
brew "ffmpeg"
brew "watchman"

# git / dev utils
brew "actionlint"
brew "git-cliff"
brew "git-lfs"
brew "git-svn"
brew "hyperfine"
brew "wrk"
brew "pngpaste"
brew "xclip"
brew "powershell"
brew "jnsahaj/lumen/lumen", trusted: true
brew "kitlangton/tap/ghui", trusted: true
brew "blankeos/tap/kondor", trusted: true

# infra / cloud
brew "awscli"
brew "b2-tools"
brew "caddy"
brew "cloudflared"
brew "flyctl"
brew "railway"
cask "vercel"   # moved from homebrew/core to cask
brew "redis"
brew "docker-buildx"
brew "tailscale"
brew "posthog/tap/posthog-cli", trusted: true
brew "schpet/tap/linear", trusted: true   # linear CLI (`linear auth`)
cask "gcloud-cli"
cask "ngrok"
cask "orbstack"
cask "docker-desktop"

# agents
brew "anomalyco/tap/opencode-v2", trusted: true
brew "herdr"
brew "claude-squad"
brew "dekit"
brew "skillshare"
brew "ollama", restart_service: :changed
brew "omsimos/tap/nosleep", trusted: true
brew "steipete/tap/gifgrep", trusted: true
cask "codex"
cask "leepokai/codync/codync", trusted: true
