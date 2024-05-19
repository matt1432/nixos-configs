{
  bazarr-bulk,
  config,
  lib,
  pkgs,
  ...
}: let
  bbPkg = bazarr-bulk.packages.${pkgs.system}.default;
in
  pkgs.writeShellApplication {
    name = "bb";
    text = ''
      exec ${lib.getExe bbPkg} --config ${config.sops.secrets.bazarr-bulk.path} "$@"
    '';
  }
