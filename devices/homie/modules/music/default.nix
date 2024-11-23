{
  config,
  mainUser,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        AlwaysPairable = true;
        PairableTimeout = 0;
        DiscoverableTimeout = 0;
        Experimental = true;
        KernelExperimental = true;
      };

      Policy.AutoEnable = true;
    };
  };

  # Have pulseaudio and spotifyd start at boot but after bluetooth
  # so bluetooth accepts sound connections from the start.
  users.users.${mainUser}.linger = true;
  systemd.user.services = {
    pulseaudio.after = ["bluetooth.service"];
    spotifyd.after = ["pulseaudio.service"];
    ueboom = {
      after = ["spotifyd.service"];
      path = with pkgs; [bluez];
      script = ''
        sleep 60
        exec bluetoothctl connect 88:C6:26:93:4B:77
      '';
    };
  };
  systemd.user.targets.default.wants = [
    "pulseaudio.service"
    "spotifyd.service"
    "ueboom.service"
  ];

  # Allow pulseaudio to be managed by MPD
  hardware.pulseaudio = {
    enable = true;

    zeroconf = {
      discovery.enable = true;
      publish.enable = true;
    };

    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };

  services = {
    upower.enable = true;

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

  home-manager.users.${mainUser}.services.spotifyd = {
    enable = true;

    package = pkgs.spotifyd.override {
      withMpris = false;
      withKeyring = false;
    };

    settings.global = {
      device_name = config.networking.hostName + " connect";
      device_type = "speaker";

      zeroconf_port = 33798;

      autoplay = false;
      backend = "pulseaudio";
      bitrate = 320;
      no_audio_cache = true;
      volume_normalisation = false;
    };
  };
}
