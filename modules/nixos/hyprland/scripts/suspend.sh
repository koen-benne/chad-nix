#!/usr/bin/env sh

# openrgb --profile ../../openrgb/profiles/asleep.orp
hyprlock &
sleep 3 && systemctl suspend
# openrgb --profile ../../openrgb/profiles/awake.orp
