{...}: {
  imports = [
    ./assist.nix
    ./firmware.nix
    ./frontend.nix
  ];

  # TODO: some components / integrations / addons require manual interaction in the GUI, find way to make it all declarative
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "caldav"
      "holiday"
      "isal"
      "met"
      "spotify"
      "upnp"
      "yamaha_musiccast"
    ];

    config = {
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
      automation = {};
      zeroconf = {};
    };
  };
}
