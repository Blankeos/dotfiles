#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chrome CDP
# @raycast.mode silent
# @raycast.packageName Browser

# Optional parameters:
# @raycast.icon /Applications/Google Chrome.app/Contents/Resources/app.icns
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Launch Chrome with remote debugging (CDP) for agent-browser
# @raycast.author carlo

# ── Configure these ──────────────────────────────────────────
CDP_PORT=9222
USER_DATA_DIR="$HOME/dotfiles/.local/chrome-cdp"
PROFILE_DIRECTORY="Default"   # profile folder inside USER_DATA_DIR (persistent)
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
# ─────────────────────────────────────────────────────────────

mkdir -p "$USER_DATA_DIR"

# Already listening? Focus that instance — don't open another blank window.
if lsof -nP -iTCP:"$CDP_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  PID=$(pgrep -f "--user-data-dir=${USER_DATA_DIR}" | head -1)
  if [ -n "$PID" ]; then
    osascript -e "tell application \"System Events\" to set frontmost of first process whose unix id is $PID to true" >/dev/null 2>&1
  fi
  echo "Chrome CDP already on :$CDP_PORT — focused"
  exit 0
fi

# No URL → Chrome restores last session from USER_DATA_DIR
open -na "Google Chrome" --args \
  --remote-debugging-port="$CDP_PORT" \
  --user-data-dir="$USER_DATA_DIR" \
  --profile-directory="$PROFILE_DIRECTORY" \
  --no-first-run \
  --no-default-browser-check

echo "Chrome CDP listening on :$CDP_PORT"
echo "Connect: agent-browser connect $CDP_PORT"
