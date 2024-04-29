-- Check if Arc is already running
set isArcRunning to false
tell application "System Events"
    if (exists process "Arc") then
        set isArcRunning to true
    end if
end tell

-- If Arc is not running, open it
if not isArcRunning then
    tell application "Arc" to activate
else
    -- If Arc is running, create a new window
    tell application "Arc"
        make new window
        activate
    end tell
end if
