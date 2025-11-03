{
  bazarr-bulk,
  config,
  lib,
  stdenv,
  writeShellApplication,
  ...
}: let
  inherit (lib) getExe;

  bbPkg = bazarr-bulk.packages.${stdenv.hostPlatform.system}.default;
in
  writeShellApplication {
    name = "bb";
    text = ''
      exec ${getExe bbPkg} --config ${config.sops.secrets.bazarr-bulk.path} "$@"
    '';
  }
