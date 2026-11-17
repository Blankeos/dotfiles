#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
updating && finish # macOS settings: first run only

log "macOS defaults"
# Text: no autocorrect / auto-capitalize
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Tab moves focus between all controls (native dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
# Three-finger drag (may need a logout)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
# Finder: show hard disks
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# Free ⌘Space for Tinycast/Raycast (Spotlight hotkey off)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'

killall Finder 2>/dev/null || true
finish
