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
      customComponents = builtins.attrValues {
        inherit
          (self.legacyPackages.${pkgs.system}.hass-components)
          extended-ollama-conversation
          tuya-local
          ;
      };

      extraComponents = [
        "esphome"
        "ollama"
        "wyoming"
        "scrape"
      ];

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

      openwakeword = {
        enable = true;
        uri = "tcp://127.0.0.1:10400";

        customModelsDirectories = ["${wakewords-src}/en/yo_homie"];
      };
    };

    esphome = {
      enable = true;
      address = "100.64.0.10";
      port = 6052;
    };
  };

  # In case tailscale is down
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;
}
