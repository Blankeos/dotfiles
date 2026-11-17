#!/usr/bin/env bash
# Set up (or update) this Mac from the repo. Safe to rerun.
#
#   bootstrap.sh dev                 agent machine: core + dev
#   bootstrap.sh dev desktop media   pick any categories (core is always added)
#   bootstrap.sh                     reuse this machine's saved categories (or ask)
#   bootstrap.sh --update            brew upgrade, then the same as above
#   bootstrap.sh --list              show categories
#
# A category is bootstrap/<name>.Brewfile plus an optional bootstrap/<name>.sh
# hook for non-brew stuff. Add a file, get a category.
set -o pipefail

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
DIR="$DOTFILES/bootstrap"
SAVED="$DOTFILES/.categories" # per machine, gitignored
export DOTFILES
source "$DIR/lib.sh"

[ "$(uname -s)" = Darwin ] || { echo "macOS only (for now)"; exit 1; }

available() { for f in "$DIR"/*.Brewfile; do basename "$f" .Brewfile; done; }
usage() { sed -n '2,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

UPDATE=0
cats=""
for a in "$@"; do
  case $a in
    -u | --update) UPDATE=1 ;;
    -l | --list)
      saved=" $(cat "$SAVED" 2>/dev/null) "
      for c in $(available); do
        case $saved in *" $c "*) m="*" ;; *) m=" " ;; esac
        printf '%s %-10s %s\n' "$m" "$c" "$(head -1 "$DIR/$c.Brewfile" | sed 's/^# [a-z]*: //')"
      done
      echo "(* = saved for this machine)"; exit 0 ;;
    -h | --help) usage; exit 0 ;;
    -*) echo "unknown flag: $a"; usage; exit 1 ;;
    *) [ -f "$DIR/$a.Brewfile" ] || { echo "no category '$a' (have: $(available | xargs))"; exit 1; }
       cats="$cats $a" ;;
  esac
done
export UPDATE

if [ -z "$cats" ] && [ -s "$SAVED" ]; then
  cats="$(cat "$SAVED")"
elif [ -z "$cats" ]; then
  echo "categories: $(available | xargs)"
  read -r -p "install which? (core is always included) > " cats
  for c in $cats; do [ -f "$DIR/$c.Brewfile" ] || { echo "no category '$c'"; exit 1; }; done
fi

# Resolve: core first, then each category after its `# needs:` deps. Dedupe, keep order.
uniq_cats=""
add_cat() {
  case " $uniq_cats " in *" $1 "*) return ;; esac
  local dep
  for dep in $(sed -n 's/^# needs: *//p' "$DIR/$1.Brewfile"); do
    [ -f "$DIR/$dep.Brewfile" ] || { echo "$1 needs unknown category '$dep'"; exit 1; }
    add_cat "$dep"
  done
  uniq_cats="$uniq_cats $1"
}
for c in core $cats; do add_cat "$c"; done
cats="${uniq_cats# }"
echo "$cats" >"$SAVED"
log "categories: $cats"

# 1. Homebrew
if ! has brew; then
  log "homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if updating; then
  log "brew upgrade"
  brew update && brew upgrade --greedy || warn "brew upgrade"
fi

# 2. Brewfiles
for c in $cats; do
  log "brew bundle: $c"
  brew bundle --no-upgrade --file "$DIR/$c.Brewfile" || warn "brew bundle: $c"
done

# 3. Configs
log "stow"
# Real files in the way (default .zshrc, a fresh ~/.claude/settings.json…) lose to the repo copy:
# move them to ~/.dotfiles-backup/<time>/ first, so stow never aborts.
conflicts="$(cd "$DOTFILES" && stow -n -R . 2>&1 | sed -n 's/.*over existing target \(.*\) since.*/\1/p')"
if [ -n "$conflicts" ]; then
  backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  while IFS= read -r t; do
    mkdir -p "$backup/$(dirname "$t")" && mv "$HOME/$t" "$backup/$t" && echo "  backed up ~/$t"
  done <<<"$conflicts"
  log "moved conflicting files to $backup"
fi
(cd "$DOTFILES" && stow -R .) || warn "stow conflicts: move the listed files away (or 'stow --adopt .' then review git diff)"

# 4. Hooks
for c in $cats; do
  [ -f "$DIR/$c.sh" ] || continue
  log "hook: $c"
  bash "$DIR/$c.sh" || warn "hook: $c"
done

if [ -n "$FAILED" ]; then
  echo; warn "finished with errors (see above). Safe to rerun."; exit 1
fi
log "done. New machine? See 'Manual steps' in README.md"
