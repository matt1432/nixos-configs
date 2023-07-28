#!/usr/bin/env bash

state () {
    if [[ $(busctl get-property --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible) == "b true" ]]; then
        echo "Running"
        eww open osk
        eww update osk-ts=true
    else
        echo "Stopped"
        eww close osk
        eww update osk-ts=false
    fi
}
                                                
toggle () {
    if [[ $(busctl get-property --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible) == "b true" ]]; then
        echo "Running"
        busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
        eww close osk
        eww update osk-ts=false
    else
        echo "Stopped"
        busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
        eww open osk
        eww update osk-ts=true
    fi
}

if [[ $1 == "getState" ]]; then
    while true; do
        sleep 0.2
        state
    done
fi

if [[ $1 == "toggle" ]];then
    toggle
fi

