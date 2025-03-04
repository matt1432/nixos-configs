{pkgs, ...}: let
  inherit (pkgs.lib) getExe mapAttrs;

  mkApp = pkg: {
    program = getExe pkg;
    type = "app";
  };
in
  mapAttrs (n: v: mkApp v) pkgs.appsPackages
