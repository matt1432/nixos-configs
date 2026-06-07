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

  # Isolate thread 11 for main Minecraft server
  # use `taskset -c 0-11` before java command in `start.sh`
  systemd.settings.Manager.CPUAffinity = "0-10";

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

        jre21 = pkgs.jdk21;
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
          jvmInitialAllocation = "12G";
          jvmPackage = jre21;

          # https://github.com/DataDalton/Minecraft-Performance-Guide/blob/main/Java%20Arguments/README.md
          jvmOpts = "-XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:+UseZGC -XX:AllocatePrefetchStyle=1 -XX:-ZProactive";

          serviceExtraPackages = with pkgs; [
            ncurses # infocmp
            util-linux # taskset
          ];

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
