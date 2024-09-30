{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe;

  turnOnUE = pkgs.writeShellApplication {
    name = "turnOnUE";

    runtimeInputs = [config.hardware.bluetooth.package];

    text = ''
      cmd=0x0003
      bt_device_addr=88:C6:26:93:4B:77

      # This is the MAC address on the first line of `bluetootctl show`
      # without the `:` and with `01` added at the end
      bt_controller_addr=E848B8C8200001

      exec gatttool -b $bt_device_addr --char-write-req --handle=$cmd --value=$bt_controller_addr
    '';
  };
in {
  environment.systemPackages = [turnOnUE];

  services.home-assistant = {
    customComponents = builtins.attrValues {
      inherit
        (self.legacyPackages.${pkgs.system}.hass-components)
        spotifyplus
        ;
    };

    extraComponents = [
      "mpd"

      # BT components
      "ibeacon"
      "led_ble"
      "kegtron"
      "xiaomi_ble"
    ];

    # Turn On the speaker automatically when openwakeword is used
    config = {
      shell_command.turn_on_ue = getExe turnOnUE;
      script.turn_on_ue = {
        alias = "Music - TurnOnUE";
        description = "Script for turning on the UE Boom 2 speaker.";
        icon = "mdi:music";
        mode = "single";

        sequence = [
          {
            alias = "Run shell command";
            service = "shell_command.turn_on_ue";
          }
        ];
      };

      automation = [
        {
          alias = "Turn On UE";
          mode = "single";
          trigger = [
            {
              platform = "state";
              entity_id = "wake_word.openwakeword";
            }
          ];
          condition = [];
          action = [
            {
              action = "shell_command.turn_on_ue";
              metadata = {};
              data = {};
            }
          ];
        }
      ];
    };
  };
}
