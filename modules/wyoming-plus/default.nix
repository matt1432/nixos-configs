{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkOption types;
  inherit (lib.modules) mkForce mkIf mkOverride;
  inherit (lib.strings) concatMapStringsSep concatStringsSep escapeShellArgs;

  cfg = config.services.wyoming;

  forkedPkg = pkgs.callPackage ./pkgs {};
in {
  options.services.wyoming.openwakeword.vadThreshold = mkOption {
    type = types.float;
    default = 0.0;
    apply = toString;
  };

  config = {
    systemd.services = mkIf (cfg.openwakeword.enable) {
      # For some reason I can't just override `ExecStart` anymore.
      wyoming-openwakeword.serviceConfig = mkForce {
        DynamicUser = true;
        User = "wyoming-openwakeword";

        MemoryDenyWriteExecute = cfg.openwakeword.package != forkedPkg;

        # changes according to https://github.com/rhasspy/wyoming-openwakeword/pull/27
        ExecStart = concatStringsSep " " [
          (getExe cfg.openwakeword.package)

          "--uri ${cfg.openwakeword.uri}"
          "--threshold ${cfg.openwakeword.threshold}"
          "--vad-threshold ${cfg.openwakeword.vadThreshold}"
          "--trigger-level ${cfg.openwakeword.triggerLevel}"

          (concatMapStringsSep " "
            (dir: "--custom-model-dir ${toString dir}")
            cfg.openwakeword.customModelsDirectories)

          (concatMapStringsSep " "
            (model: "--preload-model ${model}")
            cfg.openwakeword.preloadModels)

          (escapeShellArgs cfg.openwakeword.extraArgs)
        ];

        CapabilityBoundingSet = "";
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "all"; # reads /proc/cpuinfo
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RuntimeDirectory = "wyoming-openwakeword";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

    services.wyoming.openwakeword = mkIf (cfg.openwakeword.enable) {
      package = mkOverride 900 forkedPkg;
    };
  };
}
