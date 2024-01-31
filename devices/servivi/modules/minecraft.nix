{
  config,
  nms,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
in {
  imports = [nms.nixosModules.default];

  environment.systemPackages = [
    config.customPkgs.curseforge-server-downloader
  ];

  services = {
    borgbackup.configs.mc = {
      paths = ["/var/lib/minecraft"];
    };

    modded-minecraft-servers = {
      eula = true;
      user = mainUser;

      instances = let
        jre17 = pkgs.temurin-bin-17;

        defaults = {
          spawn-protection = 0;
          max-tick-time = 5 * 60 * 1000;
          allow-flight = true;
        };
      in {
        # Vanilla Survival
        sv = {
          enable = false;

          serverConfig =
            {
              server-port = 25569;

              extra-options = {
              };
            }
            // defaults;
        };

        # Vanilla Creative
        cv = {
          enable = true;

          jvmMaxAllocation = "6G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre17;
          jvmOpts = "";

          serverConfig =
            {
              server-port = 25566;
              motd = "creative mode gaming";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-whitelist = true;
                gamemode = "creative";
                max-players = 6;
                view-distance = 16;
              };
            }
            // defaults;
        };

        # Modded https://www.curseforge.com/minecraft/modpacks/steam-punk
        # curseforge-server-downloader --pack 643605 --version latest
        steampunk = {
          enable = false;

          jvmMaxAllocation = "12G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre17;
          jvmOpts = "";

          serverConfig =
            {
              server-port = 25569;
              motd = "";

              extra-options = {
                allow-nether = true;
                enable-command-block = true;
                enable-status = true;
                entity-broadcast-range-percentage = 100;
                force-gamemode = false;
                function-permission-level = 2;
                gamemode = "survival";
                generate-structures = true;
                max-build-height = 256;
                max-players = 8;
                difficulty = "normal";
                view-distance = 12;
                simulation-distance = 10;
                sync-chunk-writes = true;
                use-native-transport = true;
              };
            }
            // defaults;
        };

        # Vault Hunters
        vh = {
          enable = false;

          jvmMaxAllocation = "12G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre17;
          jvmOpts = "";

          serverConfig =
            {
              server-port = 25569;
              motd = "we do a little hunting of the vaults";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                entity-broadcast-range-percentage = 150;
                level-type = "default";
                max-players = 8;
                spawn-protection = 0;
                sync-chunk-writes = true;
                use-native-transport = true;
                view-distance = 10;
              };
            }
            // defaults;
        };
      };
    };
  };
}
