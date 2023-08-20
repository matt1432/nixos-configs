#!/usr/bin/env bash

on() {
  # open notif panel
  swaync-client -op

  # open closers to close when outside control center
  eww open closer-notif1
  eww open closer-notif2
  eww open closer-notif3

  eww update notif-panel-state=true
}

off() {
  swaync-client -cp

  eww update notif-panel-state=false

  eww close closer-notif1
  eww close closer-notif2
  eww close closer-notif3
}

[[ "$1" == "on" ]] && on
[[ "$1" == "off" ]] && off
