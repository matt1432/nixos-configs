{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    types
    ;

  cfg = config.services.kapowarr;
in {
  options.services.kapowarr = {
    enable = mkEnableOption "kapowarr";
    package = mkPackageOption pkgs.selfPackages "kapowarr" {};

    user = mkOption {
      type = types.str;
      default = "kapowarr";
      description = "The user account under which Kapowarr runs.";
    };

    group = mkOption {
      type = types.str;
      default = "kapowarr";
      description = "The group under which Kapowarr runs.";
    };

    port = mkOption {
      type = types.port;
      default = 5656;
      description = "Port where kapowarr should listen for incoming requests.";
    };

    urlBase = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "URL base where kapowarr should listen for incoming requests.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/kapowarr/";
      description = "The directory where Kapowarr stores its data files.";
    };

    downloadDir = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/temp_downloads";
      defaultText = "/var/lib/kapowarr/temp_downloads";
      description = "The directory where Kapowarr stores its downloaded files.";
    };

    logDir = mkOption {
      type = types.path;
      default = cfg.dataDir;
      defaultText = "/var/lib/kapowarr";
      description = "The directory where Kapowarr stores its log file.";
    };

    openFirewall = mkEnableOption "Open ports in the firewall for Kapowarr.";
  };

  config = mkIf cfg.enable {
    systemd.services.kapowarr = {
      description = "Kapowarr";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        KAPOWARR_LOG_DIR = cfg.logDir;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/kapowar") "kapowarr";
        ExecStart = toString [
          (getExe cfg.package)
          "-d ${cfg.dataDir}"
          "-D ${cfg.downloadDir}"
          "-l ${cfg.logDir}"
          "-p ${toString cfg.port}"
          (optionalString (cfg.urlBase != null) "-u ${cfg.urlBase}")
        ];

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

    networking.firewall = mkIf cfg.openFirewall {allowedTCPPorts = [cfg.port];};
  };
}
