{
  caule-themes-src,
  dracul-ha-src,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep getExe;
  inherit (pkgs.writers) writeYAML;

  themes = [
    "${caule-themes-src}/themes/caule-themes-pack-1.yaml"
    "${dracul-ha-src}/themes/dracul-ha.yaml"
  ];
in {
  systemd.services.home-assistant.preStart = let
    WorkingDirectory = "/var/lib/hass";
  in
    getExe (pkgs.writeShellApplication {
      name = "ha-themes";
      text = ''
        mkdir -p ${WorkingDirectory}/themes
        cp -f ${concatStringsSep " " themes} ${WorkingDirectory}/themes
      '';
    });

  services.home-assistant = {
    config.frontend = {
      themes = "!include_dir_merge_named themes";
    };

    lovelaceConfig = {
      title = "Our House";
      views = [
        {
          path = "home";
          title = "Home";
          cards = [
            {
              type = "entities";
              entities = [
                "switch.smartplug1"
                "switch.smartplug3"
              ];
            }
          ];
        }
      ];
    };

    config.lovelace.dashboards = {
      esphome-dash = {
        title = "ESPHome";
        icon = "mdi:car-esp";
        mode = "yaml";

        show_in_sidebar = true;
        require_admin = true;

        filename = writeYAML "esphome.yaml" {
          strategy = {
            type = "iframe";
            url = "https://esphome.nelim.org";
          };
        };
      };
    };
  };
}
