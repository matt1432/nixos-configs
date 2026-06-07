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
    pkgs.mrpack-install
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
        ports = {
          mc = 25569;
          mc2 = 25560;
          cv = 25566;
        };

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
              server-port = ports.mc;
              motd = "1.21.4 gaming";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-white-list = true;
                white-list = true;
                max-players = 10;
                view-distance = 16;
                level-seed = "8764718009920";
              };
            }
            // defaults;
        };

        # Create+ Survival https://modrinth.com/modpack/create_plus/versions
        create = {
          enable = true;

          jvmMaxAllocation = "12G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre25;

          serverConfig =
            {
              server-port = ports.mc2;
              motd = "It's creatin' time";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-white-list = true;
                white-list = true;
                max-players = 12;
                view-distance = 12;
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
              server-port = ports.cv;
              motd = "creative mode gaming";

              extra-options = {
                difficulty = "hard";
                enable-command-block = true;
                enforce-white-list = true;
                white-list = true;
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
