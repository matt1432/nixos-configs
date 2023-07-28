#!/usr/bin/env bash
eww open closer &&

WINDOW="$1"

eww open "$WINDOW"-reveal
eww update "$WINDOW"-visible=true
