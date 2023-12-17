{pkgs, ...}: let
  buildLua =
    pkgs.callPackage
    "${pkgs.path}/pkgs/applications/video/mpv/scripts/buildLua.nix" {};

  buildLuaScript = file:
    pkgs.callPackage file {inherit buildLua;};
in
  pkgs.recurseIntoAttrs {
    modernx = buildLuaScript ./modernx.nix;
    pointer-event = buildLuaScript ./pointer-event.nix;
    touch-gestures = buildLuaScript ./touch-gestures.nix;
  }
