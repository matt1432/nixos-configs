# TODO: rewrite this in NetDaemon
# From https://github.com/don86nl/ha_intents/blob/main/config/packages/assist_timers.yaml
{lib, ...}: let
  inherit (lib) concatStrings concatStringsSep;

  mkTimer = id: {
    "assist_timer${toString id}" = {
      icon = "mdi:timer-outline";
      name = "Assist - Timer ${toString id}";
      restore = true;
    };
  };

  mkLocation = id: {
    "assist_timer${toString id}_location" = {
      icon = "mdi:map-marker";
      name = "Assist - Timer ${toString id} Location";
      max = 255;
    };
  };

  entityIdList = concatStringsSep " " [
    ''{{ states.timer ''
    ''| rejectattr('state','eq','idle')''
    ''| selectattr('entity_id','match','timer.assist_timer*')''
    ''| map(attribute='entity_id')''
  ];

  settings = rec {
    timer_target = timer_target_default;
    timer_target_default = "media_player.music_player_daemon";

    timer_tts = true;
    timer_tts_service = "tts.speak";
    timer_tts_target = "tts.piper";
    timer_volume = 0.4;
    timer_tts_message = "A set timer has finished.";

    timer_media_location = "/path/to/file.mp3";
  };
in {
  services.home-assistant = {
    customSentences."assist_timers" = import ./sentences.nix;

    config = {
      homeassistant.customize."script.assist_timerstart" = {inherit settings;};

      # Make timers
      timer = (mkTimer 1) // (mkTimer 2) // (mkTimer 3);

      # Makes location of a timer customizable from the UI
      input_text = (mkLocation 1) // (mkLocation 2) // (mkLocation 3);

      intent_script = {
        TimerStart = {
          async_action = "false";
          action = [
            {
              service = "script.assist_timerstart";
              data.duration = "{{hours | int(default=0)}}:{{ minutes | int(default=0) }}:{{ seconds | int(default=0) }}";
            }
          ];
        };
        TimerStop = {
          async_action = true;
          action = [
            {
              service = "script.assist_timerstop";
              data.entity_id = "{{ entity_id }}";
            }
          ];
        };
        TimerPause = {
          async_action = true;
          action = [
            {
              service = "script.assist_timerpause";
              data = {
                entity_id = "{{ entity_id }}";
                timer_action = "{{ timer_action }}";
              };
            }
          ];
        };
        TimerDuration = {
          async_action = true;
          action = [{stop = "";}];
        };
      };

      # Automate some logic
      automation = [
        {
          alias = "Assist - TimerFinished";
          id = "assist_timerfinished";
          description = "Assist automation when set timer time is finished.";
          mode = "parallel";

          condition = [
            {
              alias = "Timer was active or paused";
              condition = "template";
              value_template = ''{{ trigger.from_state != trigger.to_state }}'';
            }
          ];

          trigger = [
            {
              alias = "Assist timer finished or cancelled";
              entity_id = ["timer.assist_timer1" "timer.assist_timer2" "timer.assist_timer3"];
              platform = "state";
              to = "idle";
            }
          ];

          action = [
            {
              alias = "Delay for Timer Reached automation";
              delay.seconds = 3;
            }

            {
              alias = "Reset timer location";
              service = "input_text.set_value";

              target.entity_id = ''{{ 'input_text.' + trigger.entity_id[6:] + '_location' }}'';

              data = {
                value = "";
              };
            }
          ];
        }
      ];

      # Scripts to start, pause and stop timers
      script = let
        entity_id = ''{% if entity_id is set or entity_id != "" %} {{ entity_id }} {% else %} null {% endif %}'';
      in {
        assist_timerpause = {
          alias = "Assist - TimerPause";
          description = "Script for pausing a timer using HA Assist.";
          icon = "mdi:assistant";
          mode = "single";

          variables = {
            inherit entity_id;
            timer_action = ''{% if timer_action is set or timer_action != "" %} {{ timer_action }} {% else %} resume {% endif %}'';
          };

          sequence = [
            {
              choose = [
                {
                  conditions = [
                    {
                      alias = "Single Timer";
                      condition = "template";
                      value_template = ''{{ entity_id[0][:18] == 'timer.assist_timer' }}'';
                    }
                  ];

                  sequence = [
                    {
                      alias = "Single timer: Idle or active";

                      choose = [
                        {
                          conditions = [
                            {
                              alias = "Timer not active";
                              condition = "template";
                              value_template = ''{{ states(entity_id) == 'idle' }}'';
                            }
                          ];

                          sequence = [
                            {stop = "Timer is not active";}
                          ];
                        }
                      ];

                      default = [
                        {
                          alias = "Pause or resume";

                          choose = [
                            {
                              alias = "Pause";

                              conditions = [
                                {
                                  alias = "Action = pause";
                                  condition = "template";
                                  value_template = ''{{ timer_action == 'pause' }}'';
                                }
                              ];

                              sequence = [
                                {
                                  alias = "Pause timer";
                                  service = "timer.pause";

                                  target.entity_id = ''{{ entity_id }}'';
                                }
                                {stop = "Pause timer";}
                              ];
                            }
                          ];

                          default = [
                            {
                              alias = "Resume timer";
                              service = "timer.start";

                              target.entity_id = ''{{ entity_id }}'';
                            }
                            {stop = "Resume timer";}
                          ];
                        }
                      ];
                    }
                  ];
                }

                {
                  alias = "No specific timer";

                  conditions = [
                    {
                      alias = "No specific Timer";
                      condition = "template";
                      value_template = ''{{ entity_id == 'null' or entity_id | list | length == 0 }}'';
                    }

                    {
                      alias = "Timer(s) are active";
                      condition = "template";
                      value_template = ''${entityIdList} | list | length > 0 }}'';
                    }
                  ];

                  sequence = [
                    {
                      alias = "No specific timer: # active?";

                      choose = [
                        {
                          conditions = [
                            {
                              alias = "No specific timer asked";
                              condition = "template";
                              value_template = ''{{ entity_id == 'null' or entity_id | list | length == 0 }}'';
                            }

                            {
                              alias = "Multiple timers active";
                              condition = "template";
                              value_template = ''${entityIdList} | list | length > 1 }}'';
                            }
                          ];

                          sequence = [
                            {stop = "Multiple timers active, none specified";}
                          ];
                        }
                      ];

                      default = [
                        {
                          alias = "Pause or resume";

                          choose = [
                            {
                              alias = "Pause";

                              conditions = [
                                {
                                  alias = "Action = pause";
                                  condition = "template";
                                  value_template = ''{{ timer_action == 'pause' }}'';
                                }
                              ];

                              sequence = [
                                {
                                  alias = "Pause timer";
                                  service = "timer.pause";

                                  target.entity_id = ''${entityIdList} | join(', ') }}'';
                                }
                                {stop = "Pause timer";}
                              ];
                            }
                          ];

                          default = [
                            {
                              alias = "Resume timer";
                              service = "timer.start";

                              target.entity_id = ''${entityIdList} | join(', ') }}'';
                            }
                            {stop = "Resume timer";}
                          ];
                        }
                      ];
                    }
                  ];
                }

                {
                  alias = "All timers";

                  conditions = [
                    {
                      alias = "All timers";
                      condition = "template";
                      value_template = ''{{ entity_id[0] == 'all' }}'';
                    }
                  ];

                  sequence = [
                    {
                      alias = "Timers active?";

                      choose = [
                        {
                          alias = "No timers active";

                          conditions = [
                            {
                              alias = "No timers active";
                              condition = "template";
                              value_template = ''${entityIdList} | list | length == 0 }}'';
                            }
                          ];

                          sequence = [
                            {stop = "No timers active";}
                          ];
                        }
                      ];

                      default = [
                        {
                          alias = "Pause or resume";

                          choose = [
                            {
                              alias = "Pause";

                              conditions = [
                                {
                                  alias = "Action = pause";
                                  condition = "template";
                                  value_template = ''{{ timer_action == 'pause' }}'';
                                }
                              ];

                              sequence = [
                                {
                                  alias = "Pause timer";
                                  service = "timer.pause";
                                  target.entity_id = ''${entityIdList} | join(', ') }}'';
                                }
                                {stop = "Pause timer";}
                              ];
                            }
                          ];

                          default = [
                            {
                              alias = "Resume timer";
                              service = "timer.start";

                              target.entity_id = ''${entityIdList} | join(', ') }}'';
                            }
                            {stop = "Resume timer";}
                          ];
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };

        assist_timerstart = {
          alias = "Assist - TimerStart";
          description = "Script for starting a timer using HA Assist.";
          icon = "mdi:assistant";
          mode = "single";

          variables = {inherit settings;};

          sequence = [
            {
              alias = "Set variables";

              variables = {
                timer_location = concatStrings [
                  ''{%- if settings.get('timer_target')[:13] == "media_player." %}''
                  ''{{ area_name(settings.get('timer_target')) | lower }}''

                  ''{% elif (settings.get('timer_target')[:7] == "sensor." or settings.get('timer_target')[:11] == "input_text.") and states(settings.get('timer_target'))[:13] == "media_player." %}''
                  ''{{- states(settings.get('timer_target')) }}''

                  ''{%- elif settings.get('timer_target')[:13] != "media_player." and settings.get('timer_target')[:7] != "sensor." and settings.get('timer_target')[:11] != "input_text." %}''
                  ''{{- settings.get('timer_target') }}''

                  ''{%- elif (settings.get('timer_target')[:7] == "sensor." or settings.get('timer_target')[:11] == "input_text.") and (states(settings.get('timer_target')) != "") and (states(settings.get('timer_target'))[:13] == "media_player.") %}''
                  ''{{ area_name(settings.get('timer_target_default')) }} ''

                  ''{%- elif (settings.get('timer_target')[:7] == "sensor." or settings.get('timer_target')[:11] == "input_text.") %}''
                  ''{% if states(settings.get('timer_target')) != "" and states(settings.get('timer_target')) != "not_home" and states(settings.get('timer_target')) != 0 %}''
                  ''{{ states(settings.get('timer_target')) }}''

                  ''{% else %}''
                  ''{{- area_name(settings.get('timer_target_default')) | lower }}''
                  ''{%- endif %}''

                  ''{%- else %}''
                  ''{{- area_name(settings.get('timer_target')) | lower }}''
                  ''{%- endif %}''
                ];
              };
            }

            {
              alias = "Set timer location";
              service = "input_text.set_value";

              target.entity_id = concatStrings [
                ''{% if states('timer.assist_timer1') != 'active' and states('timer.assist_timer1') != 'paused' %}''
                ''input_text.assist_timer1_location''

                ''{% elif states('timer.assist_timer2') != 'active' and states('timer.assist_timer2') != 'paused' %}''
                ''input_text.assist_timer2_location''

                ''{% else %}''
                ''input_text.assist_timer3_location''
                ''{% endif%}''
              ];

              data = {
                value = ''{{ timer_location }}'';
              };
            }

            {
              alias = "Start timer";
              service = "timer.start";

              target.entity_id = concatStrings [
                ''{% if states('timer.assist_timer1') != 'active' and states('timer.assist_timer1') != 'paused' %}''
                ''timer.assist_timer1''

                ''{% elif states('timer.assist_timer2') != 'active' and states('timer.assist_timer2') != 'paused' %}''
                ''timer.assist_timer2''

                ''{% else %}''
                ''timer.assist_timer3''
                ''{% endif%}''
              ];

              data_template = {
                duration = ''{{ duration }}'';
              };
            }
          ];
        };

        assist_timerstop = {
          alias = "Assist - TimerStop";
          description = "Script for stopping a timer using HA Assist.";
          icon = "mdi:assistant";
          mode = "single";

          variables = {inherit entity_id;};

          sequence = [
            {
              alias = "Set variables";
              variables = {inherit entity_id;};
            }

            {
              choose = [
                {
                  alias = "Stop Timer music";

                  conditions = [
                    {
                      alias = "Timer is a media file";
                      condition = "template";
                      value_template = ''{{ timer_tts == false }}'';
                    }

                    {
                      condition = "template";
                      value_template = ''
                        {% set mediaplayer = namespace(entity=[]) %}
                        {% for player in states.media_player %}
                          {%- if ((state_attr(player.entity_id, 'media_content_id') |lower != 'none' and state_attr(player.entity_id, 'media_content_id')[:47][38:] == 'timer.mp3') or state_attr(player.entity_id, 'media_title') | lower == 'timer') and states(player.entity_id) == 'playing' -%}
                            {%- set mediaplayer.entity = player.entity_id -%}
                          {% endif -%}
                        {% endfor %}
                        {{ mediaplayer.entity[:12] == 'media_player' }}
                      '';
                    }
                  ];

                  sequence = [
                    {
                      alias = "Stop timer music";
                      service = "media_player.media_stop";

                      target.entity_id = ''
                        {% set mediaplayer = namespace(entity=[]) %}
                        {% for player in states.media_player %}
                          {% if ((state_attr(player.entity_id, 'media_content_id') |lower != 'none' and state_attr(player.entity_id, 'media_content_id')[:47][38:] == 'timer.mp3') or state_attr(player.entity_id, 'media_title') | lower == 'timer') and states(player.entity_id) == 'playing' %}
                            {% set mediaplayer.entity = player.entity_id %}
                          {% endif %}
                        {% endfor %} {{ mediaplayer.entity }}'';
                    }
                  ];
                }

                {
                  conditions = [
                    {
                      alias = "Single Timer";
                      condition = "template";
                      value_template = ''{{ entity_id[0][:18] == 'timer.assist_timer' }}'';
                    }
                  ];

                  sequence = [
                    {
                      alias = "Single timer: Idle or active";

                      choose = [
                        {
                          conditions = [
                            {
                              alias = "Timer not active";
                              condition = "template";
                              value_template = ''{{ states(entity_id) == 'idle' }}'';
                            }
                          ];

                          sequence = [
                            {stop = "Timer is not active";}
                          ];
                        }
                      ];

                      default = [
                        {
                          alias = "Reset timer location value";
                          service = "input_text.set_value";

                          target.entity_id = ''${entityIdList} | join('_location, ') | replace('timer.', 'input_text.') }}'';

                          data = {
                            value = "0";
                          };
                        }

                        {
                          alias = "Cancel single timer";
                          service = "timer.cancel";

                          target.entity_id = ''{{ entity_id }}'';
                        }

                        {stop = "Timer cancelled";}
                      ];
                    }
                  ];
                }

                {
                  alias = "No specific timer";

                  conditions = [
                    {
                      alias = "No specific Timer";
                      condition = "template";
                      value_template = ''{{ entity_id == 'null' or entity_id | list | length == 0 }}'';
                    }

                    {
                      alias = "Timer(s) are active";
                      condition = "template";
                      value_template = ''${entityIdList} | list | length > 0 }}'';
                    }
                  ];

                  sequence = [
                    {
                      alias = "No specific timer: # active?";

                      choose = [
                        {
                          conditions = [
                            {
                              alias = "No specific timer asked";
                              condition = "template";
                              value_template = ''{{ entity_id == 'null' or entity_id | list | length == 0 }}'';
                            }

                            {
                              alias = "Multiple timers active";
                              condition = "template";
                              value_template = ''${entityIdList} | list | length > 1 }}'';
                            }
                          ];

                          sequence = [
                            {stop = "Multiple timers active, none specified";}
                          ];
                        }
                      ];

                      default = [
                        {
                          alias = "Cancel single timer";
                          service = "timer.cancel";

                          target.entity_id = ''${entityIdList} | join(', ') }}'';
                        }

                        {
                          alias = "Reset timer location value";
                          service = "input_text.set_value";
                          metadata = {};

                          target.entity_id = ''${entityIdList} | join('_location, ') | replace('timer.', 'input_text.') }}'';

                          data = {value = "0";};
                        }

                        {stop = "Timer cancelled";}
                      ];
                    }
                  ];
                }

                {
                  alias = "All timers";

                  conditions = [
                    {
                      alias = "All timers";
                      condition = "template";
                      value_template = ''{{ entity_id[0] == 'all' }}'';
                    }
                  ];

                  sequence = [
                    {
                      alias = "Timers active?";

                      choose = [
                        {
                          alias = "No timers active";

                          conditions = [
                            {
                              alias = "No timers active";
                              condition = "template";
                              value_template = ''${entityIdList} | list | length == 0 }}'';
                            }
                          ];

                          sequence = [
                            {stop = "No timers active";}
                          ];
                        }
                      ];

                      default = [
                        {
                          alias = "Cancel all timers";
                          service = "timer.cancel";

                          target.entity_id = ''${entityIdList} | join(', ') }}'';
                        }

                        {stop = "Cancel all timers";}
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };
  };
}
