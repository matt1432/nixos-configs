# From https://github.com/jan4843/config/blob/aad23c4c0d169af09b8eb5a2bd75e4728ef5fae7/modules/home/tcc/default.nix
self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatMapAttrsStringSep
    concatMapStringsSep
    escapeShellArg
    escapeShellArgs
    getExe
    mapAttrs
    mkIf
    mkOption
    optionals
    optionalString
    types
    ;

  inherit (pkgs.stdenv.hostPlatform) isDarwin system;

  services = import ./src/services.nix config.home.homeDirectory;

  cfg = config.darwin;

  tccutil = self.packages.${system}.tccutil;
in {
  options.darwin = {
    tcc = mapAttrs (_: _:
      mkOption {
        type = types.listOf types.path;
        default = [];
      })
    services;

    # TODO: add full TCC DB declarative control by force deleting it on every activation
    tccutil = {
      Global = mkOption {
        type = types.listOf types.path;
        default = [];
      };

      User = mkOption {
        type = types.listOf types.path;
        default = [];
      };
    };
  };

  config = mkIf isDarwin {
    home.packages = optionals (cfg.tccutil.Global != [] || cfg.tccutil.User != []) [tccutil];

    home.activation = {
      checkFullDiskAccess =
        lib.hm.dag.entryBefore ["checkFilesChanged"]
        # bash
        ''
          if ! head -c1 ${escapeShellArg services.SystemPolicyAllFiles.database} &>/dev/null; then
              echo "the application running this script does not have full disk access"
              exit 1
          fi
        '';

      ensureTCCPermissions = let
        tccExe = "${getExe pkgs.bash} ${./src/tcc.bash}";
      in
        lib.hm.dag.entryAfter ["installPackages"] (
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

      runTCCUtil = let
        # FIXME: find better way to run sudo in home activation
        sudoExe = "/usr/bin/sudo";
        tccExe = getExe tccutil;
      in
        lib.hm.dag.entryAfter ["installPackages"] ((
            concatMapStringsSep "\n" (
              app:
              # bash
              ''
                for entry in $(${sudoExe} ${tccExe} -l); do
                    if [[ "${app}" != "$entry" ]] && [[ "$(basename "${app}")" == "$(basename "$entry")" ]]; then
                        ${sudoExe} ${tccExe} -r "$entry"
                    fi
                done

                ${sudoExe} ${tccExe} --insert ${app}
                ${sudoExe} ${tccExe} --enable ${app}
              ''
            )
            cfg.tccutil.Global
          )
          + "\n"
          + (
            concatMapStringsSep "\n" (
              app:
              # bash
              ''
                for entry in $(tccutil -l -u); do
                    if [[ "${app}" != "$entry" ]] && [[ "$(basename "${app}")" == "$(basename "$entry")" ]]; then
                        ${tccExe} -r "$entry" -u
                    fi
                done

                ${tccExe} --insert ${app} -u
                ${tccExe} --enable ${app} -u
              ''
            )
            cfg.tccutil.User
          ));
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
