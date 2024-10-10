{
  caule-themes-src,
  dracul-ha-src,
  material-rounded-theme-src,
  material-symbols-src,
  pkgs,
  ...
}: let
  inherit (pkgs.writers) writeYAML;
in {
  services.home-assistant = {
    configFiles = {
      "themes/caule.yaml".source = "${caule-themes-src}/themes/caule-themes-pack-1.yaml";
      "themes/dracul-ha.yaml".source = "${dracul-ha-src}/themes/dracul-ha.yaml";
      "themes/material_rounded.yaml".source = "${material-rounded-theme-src}/themes/material_rounded.yaml";
    };

    customLovelaceModules = builtins.attrValues {
      inherit
        (pkgs.home-assistant-custom-lovelace-modules)
        card-mod
        ;

      material-symbols = pkgs.stdenv.mkDerivation {
        pname = "material-symbols";
        version = "0.0.0+${material-symbols-src.shortRev}";
        src = material-symbols-src;
        phases = ["installPhase"];
        installPhase = ''
          mkdir $out
          cp $src/dist/material-symbols.js $out
        '';
      };
    };

    config.frontend = {
      themes = "!include_dir_merge_named themes";
      extra_module_url = ["/local/nixos-lovelace-modules/card-mod.js"];
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
