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
    (pkgs.buildGo127Module rec {
      pname = "mrpack-install";
      version = "0.22.0-beta";

      src = pkgs.fetchFromGitHub {
        owner = "nothub";
        repo = "mrpack-install";
        rev = "v${version}";
        hash = "sha256-pVbk4jQCoeqLrDLoCB37blr5pxt1/Yvdg5uwW+bF1cE=";
      };

      vendorHash = "sha256-2Lr8Ug1ErwtKt4sdrPV4rmh8pd74PHq88ZJG8MBvjNI=";

      doCheck = false;

      postFixup = ''
        mv "$out/bin/mrpack-install" "$out/bin/mrpack-install-beta"
      '';
    })
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

        jre21 = pkgs.jdk21;
        jre25 = pkgs.temurin-bin-25;

        defaults = {
          spawn-protection = 0;
          max-tick-time = 5 * 60 * 1000;
          allow-flight = true;
        };

        defaultsExtra = {
          enable-command-block = true;
          enforce-white-list = true;
          enforce-whitelist = true;
          white-list = true;
        };
      in {
        # Vanilla Survival
        sv = {
          enable = false;

          jvmMaxAllocation = "8G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre25;

          serverConfig =
            {
              server-port = ports.mc;
              motd = "1.21.4 gaming";

              extra-options =
                {
                  difficulty = "hard";
                  max-players = 10;
                  view-distance = 16;
                  level-seed = "8764718009920";
                }
                // defaultsExtra;
            }
            // defaults;
        };

        # Cobbleverse https://modrinth.com/modpack/cobbleverse/versions
        cob = {
          enable = true;

          jvmMaxAllocation = "12G";
          jvmInitialAllocation = "12G";
          jvmPackage = jre21;

          # https://github.com/DataDalton/Minecraft-Performance-Guide/blob/main/Java%20Arguments/README.md
          jvmOpts = "-XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:+UseZGC -XX:AllocatePrefetchStyle=1 -XX:-ZProactive";

          serviceExtraPackages = with pkgs; [
            ncurses # infocmp
          ];

          serverConfig =
            {
              server-port = ports.mc2;
              motd = "gotta catch em all";

              extra-options =
                {
                  difficulty = "hard";
                  max-players = 12;
                  view-distance = 12;
                  simulation-distance = 8;
                  level-seed = "-7304550136147349891";
                }
                // defaultsExtra;
            }
            // defaults;
        };

        # Vanilla Creative
        cv = {
          enable = false;

          jvmMaxAllocation = "6G";
          jvmInitialAllocation = "2G";
          jvmPackage = jre25;

          serverConfig =
            {
              server-port = ports.cv;
              motd = "creative mode gaming";

              extra-options =
                {
                  difficulty = "hard";
                  gamemode = "creative";
                  max-players = 6;
                  view-distance = 16;
                }
                // defaultsExtra;
            }
            // defaults;
        };
      };
    };
  };

  # Periodically regenerate the chunks of a Custom Worlds dimension on Cobbleverse
  systemd = let
    dim = "moronland";
    dir = "/var/lib/minix/cob/world/dimensions/customworlds/${dim}";
  in {
    services.cob-reset-dim = {
      description = "Reset chunks of the customworlds:${dim} dimension";
      serviceConfig.Type = "oneshot";
      restartIfChanged = false;
      path = [pkgs.tmux pkgs.util-linux];

      script = ''
        say() {
          runuser -u ${mainUser} -- \
            tmux send-keys -t minix-cob:0.0 "say $1" C-m || true
        }

        wasActive=false
        if systemctl is-active --quiet minix-cob; then
          wasActive=true
          say "The ${dim} world will reset in 30 minutes. Server restarts then."
          sleep 1200
          say "The ${dim} world will reset in 10 minutes."
          sleep 300
          say "The ${dim} world will reset in 5 minutes."
          sleep 240
          say "The ${dim} world will reset in 1 minute!"
          sleep 60
          systemctl stop minix-cob
        fi

        # Never touch region files while the JVM could still be writing them
        if systemctl is-active --quiet minix-cob; then
          echo "minix-cob still active, aborting reset" >&2
          exit 1
        fi

        rm -rf "${dir}/region" "${dir}/entities" "${dir}/poi"

        if $wasActive; then
          systemctl start minix-cob
        fi
      '';
    };

    timers.cob-reset-dim = {
      wantedBy = ["timers.target"];
      # Warnings start here; the actual reset happens 30 min later
      timerConfig.OnCalendar = "Mon *-*-* 05:30:00";
    };
  };
}
