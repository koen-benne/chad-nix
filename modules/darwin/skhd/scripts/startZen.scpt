-- Check if Zen Browser is already running
set isZen BrowserRunning to false
tell application "System Events"
    if (exists process "Zen Browser") then
        set isZen BrowserRunning to true
    end if
end tell

-- If Zen Browser is not running, open it
if not isZen BrowserRunning then
    tell application "Zen Browser" to activate
else
    -- If Zen Browser is running, create a new window
    tell application "Zen Browser"
        make new window
        activate
    end tell
end if
