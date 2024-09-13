{pkgs, ...}: {
  imports = [
    ./assist.nix
    ./bluetooth.nix
    ./firmware.nix
    ./frontend.nix
  ];

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "yaml2nix";
      runtimeInputs = with pkgs; [yj];
      text = ''
        input="$(yj < "$1")"
        output="''${2:-""}"

        nixCode="$(nix eval --expr "builtins.fromJSON '''$input'''" --impure | alejandra -q | sed 's/ = null;/ = {};/g')"

        if [[ "$output" != "" ]]; then
            echo "$nixCode" > "$output"
        else
            echo "$nixCode"
        fi
      '';
    })
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
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        currency = "CAD";
        country = "CA";
        time_zone = "America/Montreal";
        external_url = "https://homie.nelim.org";
      };

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
