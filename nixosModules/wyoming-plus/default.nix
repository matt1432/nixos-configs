{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrNames
    concatMapStringsSep
    concatStringsSep
    filterAttrs
    listToAttrs
    map
    mkForce
    mkIf
    mkOverride
    nameValuePair
    optionalString
    ;

  cfg = config.services.wyoming;
in {
  config = let
    forkedPkg = import ./pkgs/wyoming-openwakeword.nix pkgs;

    whisperUnitNames = attrNames (
      filterAttrs (_: v: v.device == "cpu") cfg.faster-whisper.servers
    );
  in {
    systemd.services =
      # https://github.com/felschr/nixos-config/blob/6a0f0bf76e3ae80c1e180ba6f6c7fd3b8e91d2d3/services/home-assistant/wyoming.nix#L29
      mkIf (cfg.faster-whisper.servers != {})
      (listToAttrs (map (x:
        nameValuePair "wyoming-faster-whisper-${x}" {
          serviceConfig.ProcSubset = mkForce "all";
        })
      whisperUnitNames))
      #
      # openWakeWord
      // mkIf (cfg.openwakeword.enable) {
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
