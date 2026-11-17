# Helpers for bootstrap/*.sh hooks. Sourced, not executed.
# Hooks run after `brew bundle` + `stow`, so brew tools are on PATH.
# Keep every hook idempotent: it reruns on `bootstrap.sh --update`.

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
UPDATE="${UPDATE:-0}"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.bun/bin:$HOME/go/bin:$PATH"
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

has() { command -v "$1" >/dev/null 2>&1; }
log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; FAILED=1; }
updating() { [ "$UPDATE" = 1 ]; }

# cargo binstall: prebuilt binaries, falls back to compiling. Also upgrades.
cargo_tools() {
  has cargo-binstall || { warn "cargo-binstall missing, skipping: $*"; return; }
  for c in "$@"; do cargo binstall --no-confirm --quiet "$c" || warn "cargo: $c"; done
}

# go install <pkg>@latest (also upgrades)
go_tools() {
  has go || { warn "go missing, skipping: $*"; return; }
  for p in "$@"; do go install "$p@latest" || warn "go: $p"; done
}

# bun global packages. Prefix with + to trust its postinstall scripts.
bun_tools() {
  has bun || { warn "bun missing, skipping: $*"; return; }
  for p in "$@"; do
    case $p in
      +*) bun add -g --trust "${p#+}@latest" || warn "bun: ${p#+}" ;;
      *) bun add -g "$p@latest" || warn "bun: $p" ;;
    esac
  done
}

npm_tools() {
  has npm || { warn "npm missing, skipping: $*"; return; }
  npm install -g "${@/%/@latest}" || warn "npm: $*"
}

finish() { exit "${FAILED:-0}"; }
