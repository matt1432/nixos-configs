{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkForce mkIf mkOverride;
  inherit (lib.strings) concatMapStringsSep concatStringsSep optionalString;

  cfg = config.services.wyoming;
in {
  config = let
    forkedPkg = (import ./pkgs {inherit pkgs;}).wyoming-openwakeword;
  in {
    systemd.services = mkIf (cfg.openwakeword.enable) {
      wyoming-openwakeword.serviceConfig = {
        MemoryDenyWriteExecute = mkForce (cfg.openwakeword.package != forkedPkg);

        # changes according to https://github.com/rhasspy/wyoming-openwakeword/pull/27
        ExecStart = mkForce (concatStringsSep " " [
          "${cfg.openwakeword.package}/bin/wyoming-openwakeword"

          "--uri ${cfg.openwakeword.uri}"
          "--threshold ${cfg.openwakeword.threshold}"

          (concatMapStringsSep " "
            (dir: "--custom-model-dir ${toString dir}")
            cfg.openwakeword.customModelsDirectories)

          # removed option https://github.com/rhasspy/wyoming-openwakeword/pull/27#issuecomment-2211822998
          (optionalString
            (cfg.openwakeword.package != forkedPkg)
            (concatMapStringsSep " " (model: "--preload-model ${model}") cfg.openwakeword.preloadModels))

          # removed option since preloading was removed
          (optionalString
            (cfg.openwakeword.package != forkedPkg)
            "--trigger-level ${cfg.openwakeword.triggerLevel}")

          "${cfg.openwakeword.extraArgs}"
        ]);
      };
    };

    services.wyoming.openwakeword = mkIf (cfg.openwakeword.enable) {
      package = mkOverride 900 forkedPkg;
    };
  };
}
