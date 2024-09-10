{...}: {
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

  # Allow pulseaudio to be managed by MPD
  hardware.pulseaudio = {
    enable = true;

    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };

  # Setup MPD
  services = {
    home-assistant.extraComponents = [
      "mpd"
    ];

    mpd = {
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
  };
}
