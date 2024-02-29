#!/usr/bin/env sh

openrgb --profile ../../openrgb/profiles/asleep.orp
sleep 1
systemctl suspend
sleep 1
openrgb --profile ../../openrgb/profiles/awake.orp
