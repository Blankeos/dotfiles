#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Facebook
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📘

# Documentation:
# @raycast.description Opens facebook in the browser

tell application id "com.vivaldi.Vivaldi"
    activate
    set targetURL to "facebook.com"
    set foundTab to false
    repeat with win in windows
        set tabCount to count of tabs of win
        repeat with i from 1 to tabCount
            try
                set t to tab i of win
                set tabURL to URL of t as string
                # log "Tab " & i & " URL: [" & tabURL & "]"

                if tabURL contains targetURL then
                    # log "MATCH FOUND at tab " & i
                    set active tab index of win to i
                    set index of win to 1
                    set foundTab to true
                    exit repeat
                end if
            on error errMsg
                log "Error on tab " & i & ": " & errMsg
            end try
        end repeat
        if foundTab then exit repeat
    end repeat

    if not foundTab then
        log "No match found, opening new tab"
        make new tab at end of tabs of front window with properties {URL:"https://www.facebook.com"}
    end if
end tell
