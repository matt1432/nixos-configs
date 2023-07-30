#!/usr/bin/env bash

on () {
  eww open closer &&

  eww open quick-settings-reveal;
  eww open quick-settings-smol-reveal;
  eww open quick-settings-logo-reveal;
  eww update showqs=true
}

off () {
  eww update showqs=false
  eww close quick-settings-reveal
  eww close quick-settings-smol-reveal
  eww close quick-settings-logo-reveal
}

[[ "$1" == "on" ]] && on
[[ "$1" == "off" ]] && off
