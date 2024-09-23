{
  config,
  lib,
  pkgs,
  ...
}: {
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

    spotifyd = {
      enable = true;

      settings.global = let
        cacheDir = "/etc/spotifyd";
      in {
        device_name = config.networking.hostName + " connect";
        device_type = "speaker";

        zeroconf_port = 33798;
        cache_path = cacheDir;
        username_cmd = "${lib.getExe pkgs.jq} -r .username ${cacheDir}/credentials.json";

        autoplay = false;
        backend = "pulseaudio";
        bitrate = 320;
        no_audio_cache = true;
        volume_normalisation = false;
      };
    };
  };

  environment.etc."spotifyd/credentials.json" = {
    source = config.sops.secrets.spotifyd.path;
  };
}
