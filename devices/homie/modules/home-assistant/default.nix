{pkgs, self, ...}: {
  imports = [
    ./assist.nix
    ./bluetooth.nix
    ./firmware.nix
    ./frontend.nix
    ./netdaemon
    ./spotify.nix
    ./timer.nix

    self.nixosModules.ha-plus
  ];

  services.home-assistant = {
    enable = true;

    extraComponents = [
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

    (pkgs.writeShellApplication {
      name = "nix2yaml";
      runtimeInputs = with pkgs; [remarshal];
      text = ''
        input="$1"
        output="''${2:-""}"

        yamlCode="$(nix eval --json --file "$input" | remarshal --if json --of yaml)"

        if [[ "$output" != "" ]]; then
            echo "$yamlCode" > "$output"
        else
            echo "$yamlCode"
        fi
      '';
    })
  ];
}
