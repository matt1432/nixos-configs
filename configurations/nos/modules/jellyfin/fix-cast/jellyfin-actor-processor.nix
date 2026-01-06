{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config.sops.secrets) jellyfin-auto-collections;

  cfg = config.services.jellyfin-actor-processor;
in {
  options.services.jellyfin-actor-processor = {
    enable = mkEnableOption "jellyfin-actor-processor";

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./package.nix {};
      defaultText = literalExpression "pkgs.callPackage ./package.nix {}";
    };

    schedule = lib.mkOption {
      default = "daily";
      description = "Run interval for the timer.";
      type = lib.types.str;
    };

    jellyfinURL = mkOption {
      type = types.str;
    };

    retries = mkOption {
      type = types.int;
      default = 3;
    };

    workers = mkOption {
      type = types.int;
      default = 10;
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services.jellyfin-actor-processor = {
        wants = ["network-online.target"];
        after = ["network-online.target" "jellyfin.service"];

        serviceConfig = {
          DynamicUser = true;
          RuntimeDirectory = "jellyfin-actor-processor";
          WorkingDirectory = "%t/jellyfin-actor-processor";

          EnvironmentFile = jellyfin-auto-collections.path;

          Type = "simple";
          Restart = "on-failure";
          ExecStart = getExe (pkgs.writeShellApplication {
            name = "jellyfin-actor-processor-exec";
            text = ''
              exec ${getExe cfg.package} \
                  --url ${cfg.jellyfinURL} \
                  --api-key "$JELLYFIN_API_KEY" \
                  --retries ${toString cfg.retries} \
                  --workers ${toString cfg.workers}
            '';
          });
        };
      };

      timers.jellyfin-actor-processor = {
        partOf = ["jellyfin-actor-processor.service"];
        timerConfig = {
          OnCalendar = cfg.schedule;
          Persistent = true;
          RandomizedDelaySec = "5m";
        };
        wantedBy = ["timers.target"];
      };
    };
  };
}
