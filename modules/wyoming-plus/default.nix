{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkOption types;
  inherit (lib.modules) mkForce mkIf mkOverride;
  inherit (lib.strings) concatMapStringsSep concatStringsSep;

  cfg = config.services.wyoming;
in {
  options.services.wyoming.openwakeword.vadThreshold = mkOption {
    type = types.float;
    default = 0.0;
    apply = toString;
  };

  config = let
    forkedPkg = pkgs.callPackage ./pkgs {};
  in {
    systemd.services = mkIf (cfg.openwakeword.enable) {
      wyoming-openwakeword.serviceConfig = {
        MemoryDenyWriteExecute = mkForce (cfg.openwakeword.package != forkedPkg);

        # changes according to https://github.com/rhasspy/wyoming-openwakeword/pull/27
        ExecStart = mkForce (concatStringsSep " " [
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

          cfg.openwakeword.extraArgs
        ]);
      };
    };

    services.wyoming.openwakeword = mkIf (cfg.openwakeword.enable) {
      package = mkOverride 900 forkedPkg;
    };
  };
}
