{
  self,
  wakewords-src,
  ...
}: {
  imports = [self.nixosModules.wyoming-plus];

  services = {
    home-assistant = {
      enable = true;

      extraComponents = [
        "esphome"
        "holiday"
        "met"
        "spotify"
        "upnp"
        "wyoming"
        "yamaha_musiccast"
      ];

      config = {
        http = {
          server_host = "0.0.0.0";
          trusted_proxies = ["100.64.0.8" "100.64.0.9"];
          use_x_forwarded_for = true;
        };

        # Wanted defaults
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

    esphome = {
      enable = true;
      address = "localhost";
      port = 6052;
    };

    # Needs manual setting in GUI
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
}
