{
  config,
  nms,
  pkgs,
  ...
}: {
  imports = [nms.nixosModules.default];

  services = {
    modded-minecraft-servers = {
      eula = true;
      user = config.vars.user;

      instances = let
        jre8 = pkgs.temurin-bin-8;
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

        # Modded https://www.curseforge.com/minecraft/modpacks/nomi-ceu
        nomi = {
          enable = false;

          jvmMaxAllocation = "10G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre8;
          jvmOpts = "";

          serverConfig =
            {
              server-port = 25569;
              motd = "Nomi CEu Server, v1.7-alpha-2";

              extra-options = {
                max-players = 8;
                difficulty = 1;
                view-distance = 10;
                simulation-distance = 10;
                level-type = "lostcities";
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

          serverConfig = {
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
          } // defaults;
        };
      };
    };

    borgbackup.configs.mc = {
      paths = [
        "/var/lib/minecraft"
      ];
    };
  };
}
