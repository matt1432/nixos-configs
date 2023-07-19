#!/usr/bin/env bash

function run() {
    echo "touch up"
    exit 0
}

while IFS='$\n' read -r line; do
    [[ $(echo "$line" | grep TOUCH_UP) != "" ]] && run
done < <(stdbuf -oL journalctl --user -feu libinput-events)
