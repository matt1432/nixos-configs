{...}: {
  services.esphome.firmwareConfigs = {
    "esp1" = {
      packages.remote_package_files = {
        url = "https://github.com/esphome/firmware";
        files = ["voice-assistant/m5stack-atom-echo.adopted.yaml"];
        ref = "0f6fad0860b8bd2c251162abde5064be1ae29546";
      };

      # Enable Home Assistant API
      api.encryption.key = "!secret api_key";

      ota = [
        {
          platform = "esphome";
          password = "!secret ota_pass";
        }
      ];

      wifi = {
        ssid = "!secret wifi_ssid";
        password = "!secret wifi_password";

        manual_ip = {
          # Set this to the IP of the ESP
          static_ip = "192.168.0.92";
          # Set this to the IP address of the router. Often ends with .1
          gateway = "192.168.0.1";
          subnet = "255.255.255.0";
        };

        # Enable fallback hotspot (captive portal) in case wifi connection fails
        ap = {
          ssid = "Esp1 Fallback Hotspot";
          password = "!secret ap_fallback";
        };
      };
    };
  };
}
