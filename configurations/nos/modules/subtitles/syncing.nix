{
  bazarr-bulk,
  config,
  lib,
  system,
  writeShellApplication,
  ...
}: let
  inherit (lib) getExe;

  bbPkg = bazarr-bulk.packages.${system}.default;
in
  writeShellApplication {
    name = "bb";
    text = ''
      exec ${getExe bbPkg} --config ${config.sops.secrets.bazarr-bulk.path} "$@"
    '';
  }
