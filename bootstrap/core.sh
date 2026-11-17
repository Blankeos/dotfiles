#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# oh-my-zsh. KEEP_ZSHRC keeps the stowed ~/.zshrc symlink.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || warn "oh-my-zsh"
fi

# ZedMono Nerd Font (patched copy kept in the repo, not on brew)
mkdir -p "$HOME/Library/Fonts"
for f in "$DOTFILES/fonts/ZedMono Nerd Font"/*.ttf; do
  [ -e "$HOME/Library/Fonts/$(basename "$f")" ] || cp "$f" "$HOME/Library/Fonts/"
done

finish
