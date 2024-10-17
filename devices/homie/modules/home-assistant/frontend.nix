{
  caule-themes-src,
  dracul-ha-src,
  material-rounded-theme-src,
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.writers) writeYAML;
in {
  services.home-assistant = {
    configFiles = {
      "themes/caule.yaml".source = "${caule-themes-src}/themes/caule-themes-pack-1.yaml";
      "themes/dracul-ha.yaml".source = "${dracul-ha-src}/themes/dracul-ha.yaml";
      "themes/material_rounded.yaml".source = "${material-rounded-theme-src}/themes/material_rounded.yaml";

      "www/sidebar-config.yaml".source = writeYAML "sidebar" {
        id = "my-sidebar";

        order = [
          # Top
          {
            item = "overview";
            order = 1;
          }
          {
            match = "href";
            item = "calendar";
            order = 2;
          }
          {
            match = "href";
            item = "todo";
            order = 3;
          }

          # Bottom
          {
            bottom = true;
            item = "esphome";
            order = 5;
          }
          {
            bottom = true;
            item = "logbook";
            order = 7;
          }
          {
            bottom = true;
            icon = "mdi:tools";
            item = "developer tools";
            name = "Developer tools";
            order = 9;
          }
          {
            bottom = true;
            item = "settings";
            order = 11;
          }

          # Hidden
          {
            hide = true;
            item = "map";
          }
          {
            hide = true;
            item = "energy";
          }
          {
            hide = true;
            item = "history";
          }
          {
            hide = true;
            item = "media";
          }
        ];
      };
    };

    customLovelaceModules = builtins.attrValues {
      inherit
        (pkgs.home-assistant-custom-lovelace-modules)
        card-mod
        ;

      inherit
        (self.legacyPackages.${pkgs.system}.lovelace-components)
        material-symbols
        custom-sidebar
        ;
    };

    config.frontend = {
      themes = "!include_dir_merge_named themes";
      extra_module_url = map (p: "/local/nixos-lovelace-modules/${p}.js") [
        "card-mod"
        "custom-sidebar-yaml"
      ];
    };

    config.template = [
      {
        sensor = [
          {
            name = "Material Rounded Base Color Matt";
            unique_id = "material_rounded_base_color_matt";
            state = ''{{ states("sensor.pixel_8_accent_color") }}'';
          }
        ];
      }
    ];

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
            {
              type = "entities";
              entities = [
                "timer.assist_timer1"
                "timer.assist_timer2"
                "timer.assist_timer3"
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
