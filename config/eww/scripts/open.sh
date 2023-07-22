#!/usr/bin/env bash

WINDOW="$1"

eww open "$WINDOW"-reveal
eww update "$WINDOW"-visible=true
