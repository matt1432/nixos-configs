{
  pkgs,
  self,
  wakewords-src,
  ...
}: {
  imports = [
    self.nixosModules.esphome-plus
    self.nixosModules.wyoming-plus
  ];

  services = {
    home-assistant = {
      extraComponents = [
        "esphome"
        "ollama"
        "wyoming"
      ];

      customComponents = builtins.attrValues {
        inherit (self.legacyPackages.${pkgs.system}.hass-components) home-llm;
      };

      config = {
        assist_pipeline = {};
        conversation = {};
        media_source = {};
      };
    };

    wyoming = {
      piper.servers."en" = {
        enable = true;
        uri = "tcp://127.0.0.1:10200";

        # see https://github.com/rhasspy/rhasspy3/blob/master/programs/tts/piper/script/download.py
        voice = "en-us-ryan-low"; # using `hfc male (medium)` in GUI
        speaker = 0;
      };

      openwakeword-docker = {
        enable = true;
        uri = "127.0.0.1:10400";

        customModelsDirectories = ["${wakewords-src}/en/yo_homie"];
        preloadModels = ["yo_homie"];
      };
    };

    esphome = {
      enable = true;
      address = "100.64.0.10";
      port = 6052;
    };
  };
}
