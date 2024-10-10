{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) any attrValues concatMapStringsSep getExe mapAttrs' mkDefault mkDerivedConfig mkIf mkOption nameValuePair replaceStrings types;

  cfg = config.services.home-assistant;
  format = pkgs.formats.yaml {};
  configFilesList = attrValues cfg.configFiles;
in {
  options.services.home-assistant = {
    configFiles = mkOption {
      default = {};
      description = ''
        Set of files that have to be linked in the configuration directory.
      '';

      type = types.attrsOf (types.submodule (
        {
          name,
          config,
          options,
          ...
        }: {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether this file should be generated.  This
                option allows specific files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = ''
                Name of symlink (relative to config directory).
                Defaults to the attribute name.
              '';
            };

            text = mkOption {
              default = null;
              type = types.nullOr types.lines;
              description = "Text of the file.";
            };

            source = mkOption {
              type = types.path;
              description = "Path of the source file.";
            };
          };

          config = {
            target = mkDefault name;
            source = mkIf (config.text != null) (
              let
                name' = "haConf-" + replaceStrings ["/"] ["-"] name;
              in
                mkDerivedConfig options.text (pkgs.writeText name')
            );
          };
        }
      ));
    };

    customSentences = mkOption {
      type = types.attrsOf (types.submodule {
        freeformType = format.type;
        options.language = mkOption {
          type = types.str;
        };
      });
    };
  };

  config = mkIf cfg.enable {
    systemd.services.home-assistant =
      mkIf (
        cfg.configFiles != {} && any (c: c.enable) configFilesList
      ) {
        preStart = let
          inherit (cfg) configDir;
          mkLink = configFile: ''
            mkdir -p ${configDir}/${dirOf configFile.target}
            cp -rf ${configFile.source} ${configDir}/${configFile.target}
          '';
        in
          getExe (pkgs.writeShellApplication {
            name = "home-assistant-pre-start";
            text = concatMapStringsSep "\n" mkLink configFilesList;
          });
      };

    services.home-assistant.configFiles = mapAttrs' (n: v:
      nameValuePair "custom_sentences/${v.language}/${n}.yaml" {
        source = format.generate n v;
      })
    cfg.customSentences;
  };
}
