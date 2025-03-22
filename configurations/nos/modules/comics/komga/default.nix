{
  config,
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep getExe;
  inherit (config.sops) secrets;

  cfg = config.services.komga;
in {
  services.komga = {
    enable = true;

    user = mainUser;
    group = mainUser;

    settings = {
      server.port = 7080;
    };
  };

  # use with this https://github.com/Snd-R/komf-userscript
  systemd.services.komf = let
    stateDir = "/var/lib/komf";

    komfConf = pkgs.writers.writeJSON "application.yml" {
      komga = {
        baseUri = "https://komga.nelim.org";
        metadataUpdate.default = {
          libraryType = "COMIC";
          overrideExistingCovers = false;
          overrideComicInfo = true;
          postProcessing = {
            seriesTitle = true;
            orderBooks = true;
          };
        };
      };
      database.file = "${stateDir}/database.sqlite";
      metadataProviders.defaultProviders.comicVine = {
        priority = 1;
        enabled = true;
      };
    };
  in {
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target" "komga.service"];

    preStart = ''
      ln -sf ${komfConf} ${stateDir}/application.yml
    '';

    serviceConfig = {
      User = cfg.user;
      Group = cfg.group;

      EnvironmentFile = secrets.komf.path;

      Type = "simple";
      Restart = "on-failure";
      ExecStart = concatStringsSep " " [
        (getExe pkgs.selfPackages.komf)
        stateDir
      ];

      StateDirectory = "komf";

      # Hardening from komga service
      RemoveIPC = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      SystemCallFilter = ["@system-service"];
      ProtectSystem = "full";
      PrivateTmp = true;
      ProtectProc = "invisible";
      ProtectClock = true;
      ProcSubset = "pid";
      PrivateUsers = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectKernelTunables = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
      LockPersonality = true;
      RestrictNamespaces = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      SystemCallArchitectures = "native";
      RestrictSUIDSGID = true;
      RestrictRealtime = true;
    };
  };
}
