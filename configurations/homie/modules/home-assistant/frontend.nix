{
  caule-themes-src,
  dracul-ha-src,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues singleton;
  inherit (pkgs.writers) writeYAML;
in {
  services.home-assistant = {
    configFiles = {
      "themes/caule.yaml".source = "${caule-themes-src}/themes/caule-themes-pack-1.yaml";
      "themes/dracul-ha.yaml".source = "${dracul-ha-src}/themes/dracul-ha.yaml";
      "themes/material_you.yaml".source = "${pkgs.scopedPackages.lovelace-components.material-rounded-theme}/share/material_you.yaml";

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

    customComponents = attrValues {
      inherit
        (pkgs.scopedPackages.hass-components)
        material-symbols
        ;
    };

    customLovelaceModules = attrValues {
      inherit
        (pkgs.home-assistant-custom-lovelace-modules)
        card-mod
        light-entity-card
        universal-remote-card
        ;

      inherit
        (pkgs.scopedPackages.lovelace-components)
        big-slider-card
        custom-sidebar
        material-you-utilities
        ;
    };

    config.frontend = {
      themes = "!include_dir_merge_named themes";
      extra_module_url = map (p: "/local/nixos-lovelace-modules/${p}.js") [
        "big-slider-card"
        "card-mod"
        "custom-sidebar-yaml"
        "material-you-utilities"
      ];
    };

    config.panel_custom = [
      {
        name = "material-you-panel";
        url_path = "material-you-configuration";
        sidebar_title = "Material You Utilities";
        sidebar_icon = "mdi:material-design";
        module_url = "/local/nixos-lovelace-modules/material-you-utilities.js";
      }
    ];

    config.template = [
      {
        sensor = singleton {
          name = "Material Rounded Base Color Matt";
          unique_id = "material_rounded_base_color_matt";
          state = ''{{ states("sensor.pixel_8_accent_color") }}'';
        };
      }
    ];

    config.input_text = {
      bathroom_light_brightness = {
        name = "BathroomLightBrightness";
        icon = "mdi:lightbulb";
        # restricts to 0-100
        pattern = "^(0|[1-9][0-9]?|100)$";
        initial = "0";
        max = 3;
      };

      bathroom_light_temperature = {
        name = "BathroomLightTemperature";
        pattern = "[0-9]*";
        initial = "0";
      };
    };

    lovelaceConfig = {
      title = "Our House";
      # I don't want multiple views
      views = singleton {
        path = "home";
        title = "Home";
        cards = [
          {
            type = "entities";
            entities = [
              "switch.smartplug1"
              "switch.smartplug2"
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

          {
            type = "custom:light-entity-card";
            entity = "light.bathroomceiling";

            shorten_cards = false;
            consolidate_entities = false;
            child_card = false;
            hide_header = false;
            show_header_icon = false;
            header = "";
            color_wheel = true;
            persist_features = true;
            brightness = true;
            color_temp = true;
            white_value = true;
            color_picker = true;
            speed = true;
            intensity = false;
            force_features = false;
            show_slider_percent = true;
            full_width_sliders = true;
            brightness_icon = "weather-sunny";
            white_icon = "file-word-box";
            temperature_icon = "thermometer";
            speed_icon = "speedometer";
            intensity_icon = "transit-connection-horizontal";
          }

          {
            type = "custom:android-tv-card";

            visibility = singleton {
              condition = "state";
              entity = "remote.onn_4k_streaming_box";
              state_not = ["unavailable" "unknown"];
            };

            media_player_id = "media_player.living_room_speaker";
            keyboard_id = "remote.android_tv_192_168_0_106";
            remote_id = "remote.onn_4k_streaming_box";

            rows = [
              "navigation_buttons"
              [null "slider" null]
              [null]
              ["jellyfin" "home" "back" "keyboard"]
              [null]
            ];

            custom_actions = [
              {
                name = "center";
                type = "button";
                icon = "mdi:checkbox-blank-circle";

                styles = ''
                  :host {
                      --icon-color: rgb(94, 94, 94);
                      --size: 200px;
                      background: rgb(31, 31, 31);
                      border-radius: 200px;
                      margin: -70px;
                      padding: 70px;
                  }
                '';

                tap_action = {
                  action = "key";
                  key = "DPAD_CENTER";
                };
              }

              {
                name = "up";
                type = "button";
                icon = "mdi:chevron-up";

                styles = ''
                  :host {
                      --icon-color: rgb(197, 199, 197);
                      z-index: 2;
                      top: 25px;
                      height: 90px;
                      width: 300px;
                  }
                '';

                hold_action = {action = "repeat";};
                tap_action = {
                  action = "key";
                  key = "DPAD_UP";
                };
              }

              {
                name = "down";
                type = "button";
                icon = "mdi:chevron-down";

                styles = ''
                  :host {
                      --icon-color: rgb(197, 199, 197);
                      z-index: 2;
                      bottom: 25px;
                      height: 90px;
                      width: 300px;
                  }
                '';

                hold_action = {action = "repeat";};
                tap_action = {
                  action = "key";
                  key = "DPAD_DOWN";
                };
              }

              {
                name = "left";
                type = "button";
                icon = "mdi:chevron-left";

                styles = ''
                  :host {
                      --icon-color: rgb(197, 199, 197);
                      z-index: 2;
                      left: 30px;
                      height: 170px;
                      width: 90px;
                  }
                '';

                hold_action = {action = "repeat";};
                tap_action = {
                  action = "key";
                  key = "DPAD_LEFT";
                };
              }

              {
                name = "right";
                type = "button";
                icon = "mdi:chevron-right";

                styles = ''
                  :host {
                      --icon-color: rgb(197, 199, 197);
                      z-index: 2;
                      right: 30px;
                      height: 170px;
                      width: 90px;
                  }
                '';

                hold_action = {action = "repeat";};
                tap_action = {
                  action = "key";
                  key = "DPAD_RIGHT";
                };
              }

              {
                name = "slider";
                type = "slider";
                icon = "mdi:volume-high";

                range = [0 1];
                step = 0.01;

                tap_action = {
                  action = "perform-action";
                  perform_action = "media_player.volume_set";
                  data = {
                    volume_level = "{{ value | float }}";
                  };
                };
                value_attribute = "volume_level";
              }
            ];

            styles = ''
              #row-1 {
                  justify-content: center;
              }

              #row-2 {
                  justify-content: center;
              }

              #row-3 {
                  justify-content: center;
              }
            '';
          }
        ];
      };
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
