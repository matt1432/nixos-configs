{pkgs, ...}: let
  buildLua =
    pkgs.callPackage
    "${pkgs.path}/pkgs/applications/video/mpv/scripts/buildLua.nix" {};
in
  pkgs.recurseIntoAttrs {
    modernx = pkgs.callPackage ./modernx.nix {inherit buildLua;};
  }
