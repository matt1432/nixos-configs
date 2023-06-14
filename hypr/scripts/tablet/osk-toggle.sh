#!/usr/bin/env bash

if [[ $(busctl get-property --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible) == "b true" ]]
then
    echo "Running"
    busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
else
    echo "Stopped"
    busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
fi
