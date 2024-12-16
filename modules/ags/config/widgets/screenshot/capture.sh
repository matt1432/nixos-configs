#!/usr/bin/env bash

if [[ "$1" == "region" ]]; then
    if [[ "$2" == "true" ]]; then
        wayfreeze & PID=$!
        sleep .1
    fi

    selection="$(slurp)"

    if [[ "$2" == "true" ]]; then
        kill "$PID"
    fi

    exec grim -g "$selection" - | satty -f - || true
else
    exec grim "$@" - | satty -f - || true
fi
