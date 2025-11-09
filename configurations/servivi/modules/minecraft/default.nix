{
  mainUser,
  minix,
  pkgs,
  ...
}: {
  imports = [minix.nixosModules.default];

  nixpkgs.overlays = [minix.overlays.default];

  environment.systemPackages = [
    pkgs.curseforge-server-downloader
    pkgs.selfPackages.nbted
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
        jre25 = pkgs.temurin-bin-25;

        defaults = {
          spawn-protection = 0;
          max-tick-time = 5 * 60 * 1000;
          allow-flight = true;
        };
      in {
        # Vanilla Survival
        sv = {
          enable = true;

          jvmMaxAllocation = "8G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre25;

          serverConfig =
            {
              server-port = 25569;
              motd = "1.21.4 gaming";

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

        # Public Survival
        pv = {
          enable = true;

          jvmMaxAllocation = "12G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre25;

          serverConfig =
            {
              server-port = 25560;
              motd = "It's craftin' time";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-white-list = true;
                max-players = 12;
                view-distance = 16;
              };
            }
            // defaults;
        };

        # Vanilla Creative
        cv = {
          enable = true;

          jvmMaxAllocation = "6G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre25;

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
