-- Check if Zen Browser is already running
set isZenBrowserRunning to false
tell application "System Events"
    if (exists process "Zen Browser") then
        set isZenBrowserRunning to true
    end if
end tell

-- If Zen Browser is not running, open it
if not isZenBrowserRunning then
    tell application "Zen Browser" to activate
else
    -- If Zen Browser is running, create a new window
    tell application "Zen Browser"
        activate
    end tell
    tell application "System Events"
      keystroke "n" using {command down}
    end tell
end if
