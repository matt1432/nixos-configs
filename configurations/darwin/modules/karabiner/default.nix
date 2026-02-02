{mainUser, ...}: let
  inherit (builtins) toJSON;
in {
  home-manager.users.${mainUser} = let
    exceptTerminalCondition = type: {
      bundle_identifiers = [
        "^com\\.apple\\.Terminal$"
        "^com\\.github\\.wez\\.wezterm$"
      ];
      type = "frontmost_application_${type}";
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
                enabled = false;
                manipulators = [
                  {
                    from = {
                      key_code = "right_arrow";
                      modifiers = {mandatory = ["left_control"];};
                    };
                    to = [
                      {
                        key_code = "right_arrow";
                        modifiers = ["left_option"];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }

              {
                description = "CTRL Left Arrow to beginning of line";
                enabled = false;
                manipulators = [
                  {
                    from = {
                      key_code = "left_arrow";
                      modifiers = {mandatory = ["left_control"];};
                    };
                    to = [
                      {
                        key_code = "left_arrow";
                        modifiers = ["left_option"];
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
                    description = "Change CSA Ù to Backslash";
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
                      (exceptTerminalCondition "if")
                    ];
                    from = [{key_code = "left_control";}];
                    to = {apple_vendor_top_case_key_code = "keyboard_fn";};
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (exceptTerminalCondition "if")
                    ];
                    from = {apple_vendor_top_case_key_code = "keyboard_fn";};
                    to = [{key_code = "left_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {apple_vendor_top_case_key_code = "keyboard_fn";};
                    to = [{key_code = "left_command";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {key_code = "left_command";};
                    to = [{key_code = "left_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isLaptopKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {key_code = "left_control";};
                    to = [{apple_vendor_top_case_key_code = "keyboard_fn";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {key_code = "left_control";};
                    to = [{key_code = "left_command";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {key_code = "left_command";};
                    to = [{key_code = "left_control";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {key_code = "right_control";};
                    to = [{key_code = "right_command";}];
                    type = "basic";
                  }

                  {
                    conditions = [
                      isGSkillKeyboardCondition
                      (exceptTerminalCondition "unless")
                    ];
                    from = {key_code = "right_command";};
                    to = [{key_code = "right_control";}];
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
