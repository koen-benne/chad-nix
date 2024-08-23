#!/usr/bin/env zsh
# does not work because window is not managed

window_title="Fzf"
width=50
height=20

screen_width=$(yabai -m query --displays --display | jq -r '.frame.w')
screen_height=$(yabai -m query --displays --display | jq -r '.frame.h')

center_x=$(( ${screen_width%%.*} / 2 ))
center_y=$(( ${screen_height%%.*} / 2 ))

alacritty -o window.dimensions.columns=$width -o window.dimensions.lines=$height \
    --title=Fzf --command "$1" &

sleep 1

# Loop over all windows
yabai -m query --windows | jq -r '.[] | "\(.id) \(.app)"' | while read -r line ; do
  id=$(echo $line | cut -f1 -d' ')
  title=$(echo $line | cut -f2 -d' ')
  echo $title

  # If the window's title matches the title you're looking for
  if [[ $title == $window_title ]]; then
    # Get the window's width and height
    window_width=$(yabai -m query --windows --window $id | jq -re ".frame.w")
    window_height=$(yabai -m query --windows --window $id | jq -re ".frame.h")

    # Calculate the position for the window
    pos_x=$(( (${screen_width%%.*} - window_width) / 2 ))
    pos_y=$(( (${screen_height%%.*} - window_height) / 2 ))

    # Move the window to the calculated position
    yabai -m window $id --move abs:$pos_x:$pos_y

    # Stop the loop
    break
  fi
done
