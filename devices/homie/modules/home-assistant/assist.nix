{
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
        # Switched to HASS Ollama integration
        # inherit (self.legacyPackages.${pkgs.system}.hass-components) home-llm;
        # Home-llm prompt:
        /*
        You are 'Homie', a helpful AI Assistant that controls the devices in a house. Complete the following task as instructed.

        The current time and date is {{ (as_timestamp(now()) | timestamp_custom("%I:%M %p on %A %B %d, %Y", "EST")) }}.

        Services: {{ formatted_tools }}
        Devices:
        {{ formatted_devices }}
        */
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

  # In case tailscale is down
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;
}
