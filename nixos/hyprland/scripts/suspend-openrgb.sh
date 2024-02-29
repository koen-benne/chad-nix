#!/usr/bin/env sh

openrgb --profile ../profiles/asleep.orp
sleep 1
systemctl suspend
sleep 1
openrgb --profile ../profiles/awake.orp
