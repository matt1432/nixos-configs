{lib, ...}: let
  inherit (lib) mkForce;
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
          port = 1883;

          acl = ["pattern readwrite #"];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
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

        mqtt.server = "mqtt://localhost/1883";

        availability.enabled = true;

        frontend = {
          port = 8080;
          host = "100.64.0.10";
        };

        advanced.transmit_power = 20;
      };
    };
  };

  # Make sure it stays running through SMLIGHT reboots
  systemd.services."zigbee2mqtt".serviceConfig = {
    Restart = mkForce "always";
    StartLimitIntervalSec = 0;
  };
}
