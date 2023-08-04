#!/usr/bin/env bash

on() {
  # open notif panel
  swaync-client -op

  # open closers when outside control center
  eww open closer-notif1
  eww open closer-notif2
  eww open closer-notif3

  # reload waybar to draw over closers
  #killall -r -SIGUSR2 waybar &&

  # re open eww widgets over closers # FIXME: ??
  eww close notif-panel; eww open notif-panel &&
  eww open notif-panel-on
  eww update notif-panel-state=true

  eww close quick-settings-toggle; eww open quick-settings-toggle
  #eww close left-bar; eww open left-bar

  #if eww get osk-ts; then eww close osk; eww open osk; fi
  #if eww get tablet-ts; then eww close tablet; eww open tablet; fi
  #if eww get heart-ts; then eww close heart; eww open heart; fi
}

off() {
  swaync-client -cp
  eww close notif-panel-on

  eww update notif-panel-state=false

  eww close closer-notif1
  eww close closer-notif2
  eww close closer-notif3
}

[[ "$1" == "on" ]] && on
[[ "$1" == "off" ]] && off
