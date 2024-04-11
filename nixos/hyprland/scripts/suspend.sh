#!/usr/bin/env sh

# openrgb --profile ../../openrgb/profiles/asleep.orp
swaylock --daemonize &
sleep 1

systemctl suspend
# openrgb --profile ../../openrgb/profiles/awake.orp
