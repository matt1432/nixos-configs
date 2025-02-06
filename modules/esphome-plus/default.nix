{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) converge getExe mkOption types;
  inherit (lib.modules) mkForce mkIf;
  inherit (lib.lists) elem optionals;
  inherit (lib.strings) concatMapStringsSep optionalString;
  inherit (lib.attrsets) mapAttrsToList filterAttrsRecursive optionalAttrs;

  cfg = config.services.esphome;

  stateDir = "/var/lib/esphome";
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

  config = mkIf cfg.enable {
    users = {
      users.esphome = {
        isNormalUser = true;
        group = "esphome";
        home = stateDir;
      };
      groups.esphome = {};
    };

    # https://github.com/NixOS/nixpkgs/issues/339557
    systemd.services.esphome = {
      serviceConfig =
        (optionalAttrs (cfg.firmwareConfigs != {}) {
          ExecStartPre = getExe (pkgs.writeShellApplication {
            name = "esphome-exec-start-pre";

            runtimeInputs = optionals cfg.deleteUnmanaged [
              pkgs.findutils
            ];

            text = ''
              ${optionalString
                (cfg.secretsFile != null)
                # bash
                ''
                  cp -f "$(realpath "${cfg.secretsFile}")" ${stateDir}/secrets.yaml
                ''}

              ${optionalString
                cfg.deleteUnmanaged
                # bash
                ''
                  find ${stateDir} -name "*.yaml" ! -name "secrets.yaml" -delete
                ''}

              ${concatMapStringsSep
                "\n"
                (dev:
                  # bash
                  ''
                    cp -f "$(realpath "${dev.file}")" ${stateDir}/"${dev.name}"
                  '')
                (mapAttrsToList mkESPConf cfg.firmwareConfigs)}
            '';
          });
        })
        // {
          DynamicUser = mkForce "off";
        };
    };
  };
}
