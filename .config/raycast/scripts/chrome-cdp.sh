#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chrome CDP
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.argument1 { "type": "dropdown", "placeholder": "Profile", "data": [{"title": "Work (9222)", "value": "work"}, {"title": "Personal (9223)", "value": "personal"}] }

# Optional parameters:
# @raycast.icon /Applications/Google Chrome.app/Contents/Resources/app.icns
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Launch Chrome with remote debugging (CDP) for agent-browser
# @raycast.author carlo

# ── Configure these ──────────────────────────────────────────
# One user-data-dir + one port per identity. Never share them.
# "work" keeps the ORIGINAL dir (.local/chrome-cdp) so existing logins persist.
case "${1:-work}" in
  work)
    CDP_PORT=9222
    USER_DATA_DIR="$HOME/dotfiles/.local/chrome-cdp"
    ;;
  personal)
    CDP_PORT=9223
    USER_DATA_DIR="$HOME/dotfiles/.local/chrome-cdp-personal"
    ;;
  *)
    echo "Unknown profile: $1 (use work|personal)"
    exit 1
    ;;
esac
PROFILE_DIRECTORY="Default"   # profile folder inside USER_DATA_DIR (persistent)
# ─────────────────────────────────────────────────────────────

mkdir -p "$USER_DATA_DIR"

# Already listening? Focus that instance — don't open another blank window.
if lsof -nP -iTCP:"$CDP_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  # Anchor the match so ".../chrome-cdp" doesn't also match ".../chrome-cdp-personal"
  PID=$(pgrep -f -- "--user-data-dir=${USER_DATA_DIR}( |\$)" | head -1)
  if [ -n "$PID" ]; then
    osascript -e "tell application \"System Events\" to set frontmost of first process whose unix id is $PID to true" >/dev/null 2>&1
  fi
  echo "Chrome CDP ($1) already on :$CDP_PORT — focused"
  exit 0
fi

# No URL → Chrome restores last session from USER_DATA_DIR
open -na "Google Chrome" --args \
  --remote-debugging-port="$CDP_PORT" \
  --user-data-dir="$USER_DATA_DIR" \
  --profile-directory="$PROFILE_DIRECTORY" \
  --no-first-run \
  --no-default-browser-check

echo "Chrome CDP (${1:-work}) listening on :$CDP_PORT"
echo "Connect: agent-browser --cdp $CDP_PORT <command>"
