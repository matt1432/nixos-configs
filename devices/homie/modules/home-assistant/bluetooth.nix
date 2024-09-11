{
  config,
  lib,
  pkgs,
  ...
}: {
  # Setup Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        DiscoverableTimeout = 0;
        Experimental = true;
        KernelExperimental = true;
      };

      Policy.AutoEnable = "true";
    };
  };

  # Have pulseaudio.service itself start at boot but after bluetooth
  # so bluetooth accepts sound connections from the start.
  systemd.user.services.pulseaudio.after = ["bluetooth.service"];
  systemd.user.targets.default.wants = ["pulseaudio.service"];

  # Turn On the speaker automatically when openwakeword is used
  services.home-assistant.config = {
    shell_command.turn_on_ue = lib.getExe (pkgs.writeShellApplication {
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
    });
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

  # Allow pulseaudio to be managed by MPD
  hardware.pulseaudio = {
    enable = true;

    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };

  # Setup MPD
  services.home-assistant.extraComponents = [
    "mpd"

    # BT components
    "ibeacon"
    "led_ble"
    "kegtron"
  ];
  services.mpd = {
    enable = true;

    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };

    extraConfig = ''
      audio_output {
        type "pulse"
        name "UE Boom 2"
        sink "bluez_sink.88_C6_26_93_4B_77.a2dp_sink"
        server "127.0.0.1"
      }
    '';
  };
}
