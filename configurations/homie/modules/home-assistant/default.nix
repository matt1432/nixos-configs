{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./assist.nix
    ./bluetooth.nix
    ./firmware.nix
    ./frontend.nix
    ./zigbee.nix

    ./netdaemon
    ./spotify
    ./timer

    self.nixosModules.ha-plus
  ];

  services.home-assistant = {
    enable = true;

    extraComponents = [
      "androidtv"
      "androidtv_remote"
      "caldav"
      "cast"
      "holiday"
      "isal"
      "met"
      "switchbot"
      "upnp"
      "yamaha_musiccast"
    ];

    customComponents = builtins.attrValues {
      inherit
        (pkgs.scopedPackages.hass-components)
        yamaha-soundbar
        ;
    };

    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        currency = "CAD";
        country = "CA";
        time_zone = "America/Montreal";
        external_url = "https://homie.nelim.org";
      };

      media_player = [
        {
          platform = "yamaha_soundbar";
          host = "192.168.0.96";
          name = "Living Room Speaker";
          sources = {
            HDMI = "TV";
          };
        }
      ];

      # Proxy settings
      http = {
        server_host = "0.0.0.0";
        trusted_proxies = ["100.64.0.8" "100.64.0.9"];
        use_x_forwarded_for = true;
      };

      # `default_config` enables too much stuff. this is what I want from it
      config = {};
      dhcp = {};
      history = {};
      image_upload = {};
      logbook = {};
      mobile_app = {};
      my = {};
      sun = {};
      zeroconf = {};
    };
  };
}
