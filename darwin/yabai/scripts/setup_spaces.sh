#!/bin/bash

# Space Mapper
setup_space() {
  local idx="$1"
  local name="$2"
  local space=
  echo "setup space $idx : $name"

  space=$(yabai -m query --spaces --space "$idx")
  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  yabai -m space "$idx" --label "$name"
  if [[ "$idx" -lt "6" ]]; then
    yabai -m space "$idx" --display 1
  elif [ "$idx" -gt "6" ]; then
    yabai -m space "$idx" --display 2
  fi
}

# Setup or destroy spaces as needed to match 9
for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 9)'); do
  yabai -m space --destroy 10
done

# Set Up Spaces
setup_space 1 terminal
setup_space 2 web
setup_space 3 communcation
setup_space 4 rest
setup_space 5 rest
setup_space 6 rest
setup_space 7 rest
setup_space 8 rest
setup_space 9 rest

main_display_padding=(
  top_padding 12
  bottom_padding 12
  left_padding 12
  right_padding 12
)

# Set space padding
yabai -m config --space 1 "${main_display_padding[@]}"
yabai -m config --space 2 "${main_display_padding[@]}"
yabai -m config --space 3 "${main_display_padding[@]}"

# Set Always-Floating Spaces
yabai -m config --space 4 layout float

yabai -m rule --add app="^(Kitty|.kitty-wrapped)$" space=1
yabai -m rule --add app="^(Firefox|Brave)$" space=2
yabai -m rule --add app="^(Slack|Discord|Teams)$" space=3
yabai -m rule --add app="^(Figma|Microsoft Word)$" space=4
