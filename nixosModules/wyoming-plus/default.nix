{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrNames
    escapeShellArgs
    flatten
    filterAttrs
    hasAttr
    listToAttrs
    map
    mkEnableOption
    mkForce
    mkIf
    mkOption
    nameValuePair
    optionals
    splitString
    types
    ;

  flatMap = f: list: flatten (map f list);

  cfg = config.services.wyoming.openwakeword-docker;
in {
  options.services.wyoming.openwakeword-docker = {
    enable = mkEnableOption "Wyoming openWakeWord server";

    image = mkOption {
      type = types.package;
      default = pkgs.dockerTools.pullImage {
        imageName = "docker.io/rhasspy/wyoming-openwakeword";
        imageDigest = "sha256:88df83cfdaa5a0dd068f79662d06b81479ec7b59a4bea59751ff5d6f68bad24a";
        sha256 = "1c2yhrhhj1wpd5bcc3zaz1gv8mw8dw5m76cjf42nhf2sgwp2hsjl";
        finalImageName = "docker.io/rhasspy/wyoming-openwakeword";
        finalImageTag = "latest";
      };
      description = ''
        The image that docker will use.
      '';
    };

    uri = mkOption {
      type = types.str;
      default = "0.0.0.0:10400";
      example = "192.0.2.1:5000";
      description = ''
        URI to bind the wyoming server to.
      '';
    };

    customModelsDirectories = mkOption {
      type = types.listOf types.path;
      default = [];
      description = ''
        Paths to directories with custom wake word models (*.tflite model files).
      '';
    };

    preloadModels = mkOption {
      type = with types; listOf str;
      default = [
        "ok_nabu"
      ];
      example = [
        # wyoming_openwakeword/models/*.tflite
        "alexa"
        "hey_jarvis"
        "hey_mycroft"
        "hey_rhasspy"
        "ok_nabu"
      ];
      description = ''
        List of wake word models to preload after startup.
      '';
    };

    threshold = mkOption {
      type = types.float;
      default = 0.5;
      description = ''
        Activation threshold (0-1), where higher means fewer activations.

        See trigger level for the relationship between activations and
        wake word detections.
      '';
      apply = toString;
    };

    triggerLevel = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Number of activations before a detection is registered.

        A higher trigger level means fewer detections.
      '';
      apply = toString;
    };

    extraArgs = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Extra arguments to pass to the server commandline.
      '';
      apply = escapeShellArgs;
    };
  };

  config = {
    assertions = [
      {
        assertion =
          (cfg.enable
          && hasAttr "khepri" config
          && hasAttr "rwDataDir" config.khepri) || !cfg.enable;
        message = ''
          The module `docker` from this same flake is needed to use
          this openwakeword implementation.
        '';
      }
    ];

    systemd.services = let
      unitNames = attrNames (
        filterAttrs (_: v: v.device == "cpu") config.services.wyoming.faster-whisper.servers
      );
    in
      listToAttrs (map (x:
        nameValuePair "wyoming-faster-whisper-${x}" {
          serviceConfig.ProcSubset = mkForce "all";
        })
      unitNames);

    khepri = mkIf cfg.enable {
      compositions."openwakeword" = {
        networks.default = {};

        services."openwakeword" = {
          image = cfg.image;
          restart = "always";
          networks = ["default"];

          volumes = map (dir: "${toString dir}:${toString dir}") cfg.customModelsDirectories;
          cmd =
            (flatMap (model: ["--preload-model" model]) cfg.preloadModels)
            ++ (flatMap (dir: ["--custom-model-dir" (toString dir)]) cfg.customModelsDirectories)
            ++ ["--threshold" cfg.threshold]
            ++ ["--trigger-level" cfg.triggerLevel]
            ++ optionals (cfg.extraArgs != "") (splitString " " cfg.extraArgs);

          ports = ["${cfg.uri}:10400"];
        };
      };
    };
  };
}
