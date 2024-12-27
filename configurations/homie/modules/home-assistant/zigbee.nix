{...}: let
  zigbeeUser = "moskit";
in {
  services = {
    home-assistant = {
      extraComponents = [
        "mqtt"
        "smlight"
        "zha"
      ];
    };

    mosquitto = {
      enable = true;
      listeners = [
        {
          acl = ["topic readwrite #"];
          port = 1883;

          settings.allow_anonymous = true;

          users."${zigbeeUser}".acl = ["readwrite #"];
        }
      ];
    };

    zigbee2mqtt = {
      enable = true;
      settings = {
        serial = {
          port = "tcp://192.168.0.129:6638";
          baudrate = 115200;
          adapter = "zstack";
          disable_led = false;
        };

        mqtt = {
          server = "mqtt://localhost/1883";
          user = zigbeeUser;
        };

        frontend = {
          port = 8080;
          host = "100.64.0.10";
        };

        advanced.transmit_power = 20;
      };
    };
  };
}
