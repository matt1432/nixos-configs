{
  config,
  lib,
  pkgs,
  self,
  wakewords-src,
  ...
}: {
  imports = [self.nixosModules.wyoming-plus];

  # TODO: some components / integrations / addons require manual interaction in the GUI, find way to make it all declarative
  services = {
    home-assistant = {
      enable = true;

      extraComponents = [
        "esphome"
        "holiday"
        "isal"
        "met"
        "ollama"
        "spotify"
        "upnp"
        "wyoming"
        "yamaha_musiccast"
      ];

      customComponents = builtins.attrValues {
        inherit (self.legacyPackages.${pkgs.system}.hass-components) home-llm;
      };

      config = {
        # Proxy settings
        http = {
          server_host = "0.0.0.0";
          trusted_proxies = ["100.64.0.8" "100.64.0.9"];
          use_x_forwarded_for = true;
        };

        # Extra conf that was needed
        media_source = {};

        # GUI
        lovelace = {
          mode = "yaml";
        };

        # `default_config` enables too much stuff. this is what I want from it
        assist_pipeline = {};
        config = {};
        conversation = {};
        dhcp = {};
        history = {};
        image_upload = {};
        logbook = {};
        mobile_app = {};
        my = {};
        sun = {};
        automation = {};
        zeroconf = {};
      };
    };

    wyoming = {
      piper.servers."en" = {
        enable = true;
        uri = "tcp://127.0.0.1:10200";

        # see https://github.com/rhasspy/rhasspy3/blob/master/programs/tts/piper/script/download.py
        voice = "en-us-ryan-low";
        speaker = 0;
      };

      faster-whisper.servers."en" = {
        enable = true;
        uri = "tcp://127.0.0.1:10300";

        # see https://github.com/rhasspy/rhasspy3/blob/master/programs/asr/faster-whisper/script/download.py
        model = "small-int8";
        language = "en";
        device = "cpu";
      };

      openwakeword-docker = {
        enable = true;
        uri = "127.0.0.1:10400";

        customModelsDirectories = ["${wakewords-src}/en/yo_homie"];
        preloadModels = ["yo_homie"];
      };
    };
  };

  services.esphome = {
    enable = true;
    address = "100.64.0.10";
    port = 6052;
  };

  # FIXME: https://github.com/NixOS/nixpkgs/issues/339557
  systemd.services.esphome = let
    inherit (lib) mkForce;

    cfg = config.services.esphome;
    stateDir = "/var/lib/private/esphome";
    esphomeParams =
      if cfg.enableUnixSocket
      then "--socket /run/esphome/esphome.sock"
      else "--address ${cfg.address} --port ${toString cfg.port}";
  in {
    environment.PLATFORMIO_CORE_DIR = mkForce "/var/lib/private/esphome/.platformio";

    serviceConfig = {
      ExecStart = mkForce "${cfg.package}/bin/esphome dashboard ${esphomeParams} ${stateDir}";
      WorkingDirectory = mkForce stateDir;
    };
  };
}
