tell application "Simulator"
    activate
    tell application "System Events"
        tell process "Simulator"
            tell menu bar 1
                tell menu bar item "Simulator"
                    tell menu "Simulator"
                        click menu item "Reset Content and Settings…"
                    end tell
                end tell
            end tell
            tell window 1
                click button "Reset"
            end tell
        end tell
    end tell
end tell

