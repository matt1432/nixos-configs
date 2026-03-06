{
  mainUser,
  # pkgs,
  ...
}: let
  inherit (builtins) toJSON;

  # TODO: figure out latest Karabiner-Elements installation with nix
  /*
  package = pkgs.karabiner-elements.overrideAttrs rec {
    version = "15.9.17";

    src = pkgs.fetchurl {
      url = "https://github.com/pqrs-org/Karabiner-Elements/releases/download/beta/Karabiner-Elements-${version}.dmg";
      hash = "sha256-Rm2hBYAy6e+j/iM84dUUkc75HTGfzLQM8D9VX+RaqVk=";
    };
  };
  */
in {
  home-manager.users.${mainUser} = let
    terminalCondition = type: {
      bundle_identifiers = [
        "^com\\.apple\\.Terminal$"
        "^com\\.github\\.wez\\.wezterm$"
      ];
      type = "frontmost_application_${
        if type
        then "if"
        else "unless"
      }";
    };

    isLaptopKeyboardCondition = {
      identifiers = [
        {
          is_keyboard = true;
          product_id = 832;
          vendor_id = 1452;
        }
      ];
      type = "device_if";
    };

    isGSkillKeyboardCondition = {
      identifiers = [
        {
          is_keyboard = true;
          product_id = 4353;
          vendor_id = 10458;
        }
      ];
      type = "device_if";
    };
  in {
    xdg.configFile."karabiner/karabiner.json".text = toJSON {
      profiles = [
        {
          name = "Default profile";
          selected = true;

          complex_modifications = {
            rules = [
              {
                description = "CTRL Right Arrow to end of line";
                enabled = true;
                manipulators = [
                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition true)
                    ];
                    from = {
                      key_code = "right_arrow";
                      modifiers = {
                        mandatory = ["left_control"];
                      };
                    };
                    to = [
                      {
                        key_code = "end";
                        modifiers = [];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }

              {
                description = "CTRL Left Arrow to beginning of line";
                enabled = true;
                manipulators = [
                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition true)
                    ];
                    from = {
                      key_code = "left_arrow";
                      modifiers = {
                        mandatory = ["left_control"];
                      };
                    };
                    to = [
                      {
                        key_code = "home";
                        modifiers = [];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }

              {
                description = "Clipboard History";
                enabled = false;
                manipulators = [
                  {
                    from = {
                      key_code = "v";
                      modifiers = {
                        mandatory = ["left_command"];
                        optional = ["any"];
                      };
                    };
                    to = [
                      {
                        key_code = "spacebar";
                        modifiers = ["left_command"];
                      }
                      {
                        key_code = "4";
                        modifiers = ["left_command"];
                      }
                      {
                        key_code = "4";
                        modifiers = ["left_command"];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }

              {
                manipulators = [
                  {
                    description = "Change CSA ù to Slash";
                    from = {key_code = "grave_accent_and_tilde";};
                    to = [
                      {
                        key_code = "slash";
                        modifiers = ["right_option"];
                      }
                    ];
                    type = "basic";
                  }
                  {
                    description = "Change CSA Ù to Backslash outside terminal";
                    from = {
                      key_code = "grave_accent_and_tilde";
                      modifiers = {mandatory = ["left_shift"];};
                    };
                    to = [
                      {
                        key_code = "grave_accent_and_tilde";
                        modifiers = ["left_option"];
                      }
                    ];
                    type = "basic";
                    conditions = [
                      (terminalCondition false)
                    ];
                  }
                  {
                    description = "Change CSA Ù to Backslash inside terminal";
                    from = {
                      key_code = "grave_accent_and_tilde";
                      modifiers = {mandatory = ["left_shift"];};
                    };
                    to = [
                      {
                        key_code = "quote";
                        modifiers = ["right_option"];
                      }
                    ];
                    type = "basic";
                    conditions = [
                      (terminalCondition true)
                    ];
                  }
                  {
                    description = "Pipe";
                    from = {
                      key_code = "grave_accent_and_tilde";
                      modifiers = {mandatory = ["right_option"];};
                    };
                    to = [
                      {
                        key_code = "hyphen";
                        modifiers = ["right_option"];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }

              {
                description = "Switch Command and CTRL";
                manipulators = [
                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition true)
                    ];
                    from = [{key_code = "left_control";}];
                    to = {apple_vendor_top_case_key_code = "keyboard_fn";};
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition true)
                    ];
                    from = {apple_vendor_top_case_key_code = "keyboard_fn";};
                    to = [{key_code = "left_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {apple_vendor_top_case_key_code = "keyboard_fn";};
                    to = [{key_code = "left_command";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {key_code = "left_command";};
                    to = [{key_code = "left_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {key_code = "left_control";};
                    to = [{apple_vendor_top_case_key_code = "keyboard_fn";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {key_code = "left_control";};
                    to = [{key_code = "left_command";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {key_code = "left_command";};
                    to = [{key_code = "left_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {key_code = "right_control";};
                    to = [{key_code = "right_command";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (terminalCondition false)
                    ];
                    from = {key_code = "right_command";};
                    to = [{key_code = "right_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      (terminalCondition true)
                    ];
                    from = {
                      key_code = "left_command";
                      modifiers.optional = ["any"];
                    };
                    to = [{key_code = "left_control";}];
                    to_if_other_key_pressed = [
                      {
                        other_keys = [
                          {
                            key_code = "v";
                            modifiers.optional = ["any"];
                          }
                        ];
                        to = [{key_code = "left_command";}];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }
            ];
          };

          virtual_hid_keyboard = {keyboard_type_v2 = "ansi";};
          devices = [
            {
              identifiers = {
                is_keyboard = true;
                product_id = 49305;
                vendor_id = 1133;
              };
              ignore = true;
            }

            # Laptop Keyboard
            {
              identifiers = {
                is_keyboard = true;
                product_id = 832;
                vendor_id = 1452;
              };
              simple_modifications = [
                {
                  from = {key_code = "right_command";};
                  to = [{key_code = "right_option";}];
                }
                {
                  from = {key_code = "right_option";};
                  to = [{key_code = "right_command";}];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
