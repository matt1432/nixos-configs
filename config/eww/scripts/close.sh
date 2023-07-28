#!/usr/bin/env bash

WINDOW="$1"
(
eww update "$WINDOW"-visible=false
#sleep .55
eww close "$WINDOW"-reveal
) &
