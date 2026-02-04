# From https://github.com/jan4843/config/blob/aad23c4c0d169af09b8eb5a2bd75e4728ef5fae7/modules/home/tcc/default.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatMapAttrsStringSep
    escapeShellArg
    escapeShellArgs
    getExe
    mkIf
    mkOption
    optionalString
    types
    ;

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  services = import ./src/services.nix config.home.homeDirectory;
in {
  options.darwin.tcc =
    builtins.mapAttrs (
      _: _:
        mkOption {
          type = types.listOf types.path;
          default = [];
        }
    )
    services;

  config = mkIf isDarwin {
    home.activation.checkFullDiskAccess =
      lib.hm.dag.entryBefore ["checkFilesChanged"]
      # bash
      ''
        if ! head -c1 ${escapeShellArg services.SystemPolicyAllFiles.database} &>/dev/null; then
            echo "the application running this script does not have full disk access"
            exit 1
        fi
      '';

    home.activation.ensureTCCPermissions = let
      tccExe = "${getExe pkgs.bash} ${./src/tcc.bash}";
    in lib.hm.dag.entryAfter ["installPackages"] (
      concatMapAttrsStringSep "\n" (
        name: service:
          optionalString (config.darwin.tcc.${name} != []) ''
            TCC_DATABASE=${escapeShellArg service.database} \
            TCC_SERVICE=kTCCService${escapeShellArg name} \
            PREFPANE=${escapeShellArg service.prefpane} \
            ${tccExe} ${escapeShellArgs config.darwin.tcc.${name}} || true # script will fail on CI
          ''
      )
      services
    );
  };
}
