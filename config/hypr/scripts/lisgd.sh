#!/usr/bin/env bash

## https://www.reddit.com/r/swaywm/comments/ocec7k/comment/i93s0ma/
## https://git.sr.ht/~mil/lisgd/tree/0.3.7/item/config.def.h

function gestures {
  lisgd -d /dev/input/by-path/platform-AMDI0010\:00-event -o 0 -t 125 -r 25 -m 3200 \
    -g "1,UD,B,*,R,bash -c 'busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false'" \
    -g "1,DU,B,*,R,bash -c 'busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true'" \
    -g "1,RL,R,*,R,bash -c 'hyprctl dispatch togglespecialworkspace spot'" \
    -g "1,LR,R,*,R,bash -c 'hyprctl dispatch togglespecialworkspace spot'"
}

if pgrep lisgd ; then
  killall -r lisgd
  gestures
else
  gestures
fi
