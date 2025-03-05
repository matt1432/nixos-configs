{
  mainUser,
  minix,
  pkgs,
  ...
}: {
  imports = [minix.nixosModules.default];

  environment.systemPackages = [
    # TODO: add overlays to upstream flake
    minix.packages.${pkgs.system}.curseforge-server-downloader
  ];

  services = {
    borgbackup.configs.mc = {
      paths = ["/var/lib/minix"];
      startAt = "01/3:00";
    };

    minix = {
      eula = true;
      user = mainUser;

      instances = let
        jre21 = pkgs.temurin-bin-21;

        defaults = {
          spawn-protection = 0;
          max-tick-time = 5 * 60 * 1000;
          allow-flight = true;
        };
      in {
        # Vanilla Survival
        sv = {
          enable = true;

          jvmMaxAllocation = "10G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre21;

          serverConfig =
            {
              server-port = 25569;
              motd = "1.21 gaming";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-white-list = true;
                max-players = 10;
                view-distance = 16;
                level-seed = "8764718009920";
              };
            }
            // defaults;
        };

        # Vanilla Creative
        cv = {
          enable = true;

          jvmMaxAllocation = "8G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre21;

          serverConfig =
            {
              server-port = 25566;
              motd = "creative mode gaming";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-white-list = true;
                gamemode = "creative";
                max-players = 6;
                view-distance = 16;
              };
            }
            // defaults;
        };
      };
    };
  };
}
