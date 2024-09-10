{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatMapStringsSep
    converge
    elem
    filterAttrsRecursive
    getExe
    mapAttrsToList
    mkForce
    mkIf
    mkOption
    optionalAttrs
    optionals
    optionalString
    types
    ;

  cfg = config.services.esphome;

  stateDir = "/var/lib/private/esphome";
  esphomeParams =
    if cfg.enableUnixSocket
    then "--socket /run/esphome/esphome.sock"
    else "--address ${cfg.address} --port ${toString cfg.port}";

  format = pkgs.formats.yaml {};

  # Adapted from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/home-automation/home-assistant.nix
  mkESPConf = name: cfg: let
    filteredConfig = converge (filterAttrsRecursive (_: v: ! elem v [null])) cfg;
  in {
    name = "${name}.yaml";
    file = pkgs.runCommandLocal "${name}.yaml" {} ''
      cp ${format.generate name filteredConfig} $out
      sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
      sed -i 's/ {}//g' $out
      sed -i "s/'\"/\"/g" $out
      sed -i "s/\"'/\"/g" $out
    '';
  };
in {
  options.services.esphome = {
    firmwareConfigs = mkOption {
      default = {};
      type = with types; attrsOf anything;
    };

    secretsFile = mkOption {
      default = null;
      type = types.nullOr types.path;
    };

    deleteUnmanaged = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    # FIXME: https://github.com/NixOS/nixpkgs/issues/339557
    systemd.services.esphome = {
      environment.PLATFORMIO_CORE_DIR = mkForce "${stateDir}/.platformio";

      serviceConfig =
        (optionalAttrs (cfg.firmwareConfigs != {}) {
          ExecStartPre = getExe (pkgs.writeShellApplication {
            name = "esphome-exec-start-pre";

            runtimeInputs = optionals cfg.deleteUnmanaged [
              pkgs.findutils
            ];

            text = ''
              if [[ ! -d ${stateDir} ]]; then
                  mkdir -p ${stateDir}
              fi

              ${optionalString (cfg.secretsFile != null) ''cp -f "$(realpath "${cfg.secretsFile}")" ${stateDir}/secrets.yaml''}

              ${optionalString cfg.deleteUnmanaged ''find ${stateDir} -name "*.yaml" ! -name "secrets.yaml" -delete''}

              ${concatMapStringsSep
                "\n"
                (dev: ''cp -f "$(realpath "${dev.file}")" ${stateDir}/"${dev.name}"'')
                (mapAttrsToList mkESPConf cfg.firmwareConfigs)}
            '';
          });
        })
        // {
          ExecStart = mkForce "${cfg.package}/bin/esphome dashboard ${esphomeParams} ${stateDir}";
          WorkingDirectory = mkForce stateDir;
        };
    };
  };
}
