{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mapAttrs' mkEnableOption mkIf mkMerge mkOption mkPackageOption nameValuePair types;

  cfg = config.services.jmusicbot;

  mkInstance = _: instanceConfig:
    nameValuePair "jmusicbot-${instanceConfig.instanceName}" {
      enable = instanceConfig.enable;

      description = "JMusicBot, a Discord music bot that's easy to set up and run yourself";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];

      serviceConfig = mkMerge [
        {
          ExecStart = getExe cfg.package;
          WorkingDirectory = "${cfg.stateDir}/${instanceConfig.instanceName}";

          User = instanceConfig.user;
          Group = instanceConfig.group;
          Restart = "always";
          RestartSec = 20;
        }
        (mkIf (cfg.stateDir == "/var/lib/jmusicbot") {StateDirectory = "jmusicbot/${instanceConfig.instanceName}";})
      ];
    };
in {
  disabledModules = ["services/audio/jmusicbot.nix"];

  options.services.jmusicbot = {
    package = mkPackageOption pkgs.selfPackages "jmusicbot" {};

    defaultUser = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    defaultGroup = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    instances = mkOption {
      type = types.attrsOf (types.submodule (
        {
          name,
          config,
          ...
        }: {
          options = {
            enable = mkEnableOption "JMusicBot, a Discord music bot that's easy to set up and run yourself";

            instanceName = mkOption {
              type = types.str;
              default = name;
            };
            user = mkOption {
              type = with types; nullOr str;
              default = cfg.defaultUser or config.instanceName;
            };
            group = mkOption {
              type = with types; nullOr str;
              default = cfg.defaultGroup or config.instanceName;
            };
          };
        }
      ));
      default = {};
    };

    stateDir = mkOption {
      type = types.path;
      description = ''
        The directory where each instance's directory where config.txt and serversettings.json is saved.
        If left as the default value this directory will automatically be created before JMusicBot starts, otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership and permissions.
        Untouched by the value of this option config.txt needs to be placed manually into this directory.
      '';
      default = "/var/lib/jmusicbot";
    };
  };

  config = mkIf (cfg.instances != {}) {
    systemd.services = mapAttrs' mkInstance cfg.instances;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
