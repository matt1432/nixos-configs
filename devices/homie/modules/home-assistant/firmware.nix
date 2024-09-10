{config, ...}: {
  services.esphome = {
    secretsFile = config.sops.secrets.esphome.path;

    firmwareConfigs = {
      "esp1" = {
        # Device specific settings
        api.encryption.key = "!secret api_key";

        ota = [
          {
            platform = "esphome";
            password = "!secret ota_pass";
          }
        ];

        wifi = {
          ssid = "!secret wifi_ssid";
          password = "!secret wifi_password";

          manual_ip = {
            static_ip = "192.168.0.92";
            gateway = "192.168.0.1";
            subnet = "255.255.255.0";
          };

          ap = {
            ssid = "Esp1 Fallback Hotspot";
            password = "!secret ap_fallback";
          };
        };

        # Hardware Declaration
        esphome = {
          friendly_name = "M5Stack Atom Echo";
          min_version = "2024.6.0";
          name = "m5stack-atom-echo";
          name_add_mac_suffix = true;
        };

        esp32 = {
          board = "m5stack-atom";
          framework.type = "esp-idf";
        };

        esp_adf = {};

        button = [
          {
            id = "button_safe_mode";
            name = "Safe Mode Boot";
            platform = "safe_mode";
          }
          {
            id = "factory_reset_btn";
            name = "Factory reset";
            platform = "factory_reset";
          }
        ];

        microphone = [
          {
            adc_type = "external";
            i2s_din_pin = "GPIO23";
            id = "echo_microphone";
            pdm = true;
            platform = "i2s_audio";
          }
        ];

        speaker = [
          {
            dac_type = "external";
            i2s_dout_pin = "GPIO22";
            id = "echo_speaker";
            mode = "mono";
            platform = "i2s_audio";
          }
        ];

        i2s_audio = [
          {
            id = "i2s_audio_bus";
            i2s_bclk_pin = "GPIO19";
            i2s_lrclk_pin = "GPIO33";
          }
        ];

        light = [
          {
            id = "led";
            name = "None";
            entity_category = "config";

            chipset = "SK6812";
            pin = "GPIO27";
            platform = "esp32_rmt_led_strip";

            default_transition_length = "0s";
            disabled_by_default = false;
            num_leds = 1;
            rgb_order = "grb";
            rmt_channel = 0;

            effects = [
              {
                pulse = {
                  name = "Slow Pulse";

                  max_brightness = "100%";
                  min_brightness = "50%";
                  transition_length = "250ms";
                  update_interval = "250ms";
                };
              }
              {
                pulse = {
                  name = "Fast Pulse";

                  max_brightness = "100%";
                  min_brightness = "50%";
                  transition_length = "100ms";
                  update_interval = "100ms";
                };
              }
            ];
          }
        ];

        # Home-assistant buttons
        switch = [
          {
            id = "use_wake_word";
            name = "Use wake word";
            entity_category = "config";

            optimistic = true;
            platform = "template";
            restore_mode = "RESTORE_DEFAULT_ON";

            on_turn_on = [
              {lambda = "id(va).set_use_wake_word(true);";}
              {
                "if" = {
                  condition.not = ["voice_assistant.is_running"];
                  "then" = ["voice_assistant.start_continuous"];
                };
              }
              {"script.execute" = "reset_led";}
            ];

            on_turn_off = [
              "voice_assistant.stop"
              {lambda = "id(va).set_use_wake_word(false);";}
              {"script.execute" = "reset_led";}
            ];
          }

          {
            id = "use_listen_light";
            name = "Use listen light";
            entity_category = "config";

            optimistic = true;
            platform = "template";
            restore_mode = "RESTORE_DEFAULT_ON";

            on_turn_on = [{"script.execute" = "reset_led";}];
            on_turn_off = [{"script.execute" = "reset_led";}];
          }

          {
            id = "timer_ringing";

            internal = true;
            optimistic = true;
            platform = "template";
            restore_mode = "ALWAYS_OFF";

            on_turn_on = [
              {delay = "15min";}
              {"switch.turn_off" = "timer_ringing";}
            ];
          }
        ];

        binary_sensor = [
          {
            id = "echo_button";
            name = "Button";
            entity_category = "diagnostic";

            disabled_by_default = false;

            platform = "gpio";
            pin = {
              inverted = true;
              number = "GPIO39";
            };

            on_multi_click = [
              {
                timing = ["ON for at least 50ms" "OFF for at least 50ms"];
                "then" = [
                  {
                    "if" = {
                      condition = {"switch.is_on" = "timer_ringing";};
                      "then" = [{"switch.turn_off" = "timer_ringing";}];
                      "else" = [
                        {
                          "if" = {
                            condition = {"switch.is_off" = "use_wake_word";};
                            "then" = [
                              {
                                "if" = {
                                  condition = "voice_assistant.is_running";
                                  "then" = [
                                    {"voice_assistant.stop" = {};}
                                    {"script.execute" = "reset_led";}
                                  ];
                                  "else" = [{"voice_assistant.start" = {};}];
                                };
                              }
                            ];
                            "else" = [
                              "voice_assistant.stop"
                              {delay = "1s";}
                              {"script.execute" = "reset_led";}
                              {"script.wait" = "reset_led";}
                              {"voice_assistant.start_continuous" = {};}
                            ];
                          };
                        }
                      ];
                    };
                  }
                ];
              }
              {
                timing = ["ON for at least 10s"];
                "then" = [{"button.press" = "factory_reset_btn";}];
              }
            ];
          }
        ];

        # Misc
        logger = {};

        external_components = [
          {
            source = "github://pr#5230";
            components = ["esp_adf"];
            refresh = "0s";
          }
          {
            source = "github://jesserockz/esphome-components";
            components = ["file"];
            refresh = "0s";
          }
        ];

        file = [
          {
            file = "https://github.com/esphome/firmware/raw/main/voice-assistant/sounds/timer_finished.wav";
            id = "timer_finished_wave_file";
          }
        ];

        # Configs
        script = [
          {
            id = "reset_led";
            "then" = [
              {
                "if" = {
                  condition = [
                    {"switch.is_on" = "use_wake_word";}
                    {"switch.is_on" = "use_listen_light";}
                  ];
                  "then" = [
                    {
                      "light.turn_on" = {
                        id = "led";
                        brightness = "60%";
                        effect = "none";

                        red = "100%";
                        green = "89%";
                        blue = "71%";
                      };
                    }
                  ];
                  "else" = [{"light.turn_off" = "led";}];
                };
              }
            ];
          }
        ];

        voice_assistant = {
          id = "va";
          speaker = "echo_speaker";
          microphone = "echo_microphone";
          auto_gain = "31dBFS";

          noise_suppression_level = 2;
          vad_threshold = 3;
          volume_multiplier = 2;

          on_client_connected = [
            {
              "if" = {
                condition = {"switch.is_on" = "use_wake_word";};
                "then" = [
                  {"voice_assistant.start_continuous" = {};}
                  {"script.execute" = "reset_led";}
                ];
              };
            }
          ];
          on_client_disconnected = [
            {
              "if" = {
                condition = {"switch.is_on" = "use_wake_word";};
                "then" = [
                  {"voice_assistant.stop" = {};}
                  {"light.turn_off" = "led";}
                ];
              };
            }
          ];
          on_end = [
            {delay = "100ms";}
            {wait_until.not."speaker.is_playing" = {};}
            {"script.execute" = "reset_led";}
          ];
          on_error = [
            {
              "light.turn_on" = {
                id = "led";
                brightness = "100%";
                effect = "none";

                red = "100%";
                green = "0%";
                blue = "0%";
              };
            }
            {delay = "1s";}
            {"script.execute" = "reset_led";}
          ];
          on_listening = [
            {
              "light.turn_on" = {
                id = "led";
                effect = "Slow Pulse";

                green = "0%";
                red = "0%";
                blue = "100%";
              };
            }
          ];
          on_stt_vad_end = [
            {
              "light.turn_on" = {
                id = "led";
                effect = "Fast Pulse";

                red = "0%";
                green = "0%";
                blue = "100%";
              };
            }
          ];
          on_timer_finished = [
            {"voice_assistant.stop" = {};}
            {"switch.turn_on" = "timer_ringing";}
            {wait_until.not."microphone.is_capturing" = {};}
            {
              "light.turn_on" = {
                id = "led";
                brightness = "100%";
                effect = "Fast Pulse";

                red = "0%";
                green = "100%";
                blue = "0%";
              };
            }
            {
              while = {
                condition = {"switch.is_on" = "timer_ringing";};
                "then" = [
                  {lambda = "id(echo_speaker).play(id(timer_finished_wave_file), sizeof(id(timer_finished_wave_file)));";}
                  {delay = "1s";}
                ];
              };
            }
            {wait_until.not."speaker.is_playing" = {};}
            {"light.turn_off" = "led";}
            {"switch.turn_off" = "timer_ringing";}
            {
              "if" = {
                condition = {"switch.is_on" = "use_wake_word";};
                "then" = [
                  {"voice_assistant.start_continuous" = {};}
                  {"script.execute" = "reset_led";}
                ];
              };
            }
          ];
          on_tts_start = [
            {
              "light.turn_on" = {
                id = "led";
                brightness = "100%";
                effect = "none";

                red = "0%";
                green = "0%";
                blue = "100%";
              };
            }
          ];
        };
      };
    };
  };
}
