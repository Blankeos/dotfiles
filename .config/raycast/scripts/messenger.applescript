#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Messenger
# @raycast.mode silent

# Optional parameters:
# @raycast.icon messenger.png

# Documentation:
# @raycast.description Opens an existing messenger tab in browser

tell application id "com.vivaldi.Vivaldi"
    activate
    repeat 50 times
        if (count of windows) > 0 then exit repeat
        delay 0.1
    end repeat

    set foundTab to false
    repeat with win in windows
        try
            set allURLs to URL of every tab of win
        on error
            next
        end try
        if (count of allURLs) > 0 then
            repeat with i from 1 to count of allURLs
                set tabURL to item i of allURLs as string
                if tabURL contains "www.facebook.com/messages" and tabURL does not contain "www.facebook.com/messages/groupcall" then
                    set active tab index of win to i
                    set index of win to 1
                    set foundTab to true
                    exit repeat
                end if
            end repeat
            if foundTab then exit repeat
        end if
    end repeat

    if not foundTab then
        make new tab at end of tabs of front window with properties {URL:"https://www.facebook.com/messages"}
    end if
end tell
