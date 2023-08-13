#!/usr/bin/env bash

FILE="$HOME/.config/.on-release"

function run() {
  echo "can_run" > "$FILE"
}

while IFS='$\n' read -r line; do
    if [[ $(echo "$line" | grep TOUCH_UP) != "" ]]; then
      run
      if [[ $(echo "$line" | grep '1 (1)') != "" ]]; then
        eww update cancel_touch=false
      fi
    elif [[ $(echo "$line" | grep release) != "" ]]; then
      run
    elif [[ $(echo "$line" | grep 'TOUCH_DOWN.*1 (1)') != "" ]]; then
      eww update cancel_touch=true
    else
      echo "other" > "$FILE"
    fi
done < <(stdbuf -oL libinput debug-events)
