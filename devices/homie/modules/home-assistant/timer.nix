# From https://github.com/don86nl/ha_intents/blob/main/config/packages/assist_timers.yaml
{...}: let
  settings = {
    timer_media_location = "/path/to/file.mp3";
    timer_target = "kitchen";
    timer_target_default = "media_player.music_player_daemon";
    timer_tts = true;
    timer_tts_message = "A set timer has finished.";
    timer_tts_service = "tts.speak";
    timer_tts_target = "tts.piper";
    timer_volume = 0.4;
  };
in {
  services.home-assistant = {
    config = {
      # TODO: format this properly
      automation = [
        {
          action = [
            {
              alias = "Get generic variables from script";
              variables = {
                timer_media_location = "{{ settings.get('timer_media_location') }}";
                timer_target = "{%- if settings.get('timer_target')[:13] == \"\" %} {{- settings.get('timer_target_default') }} {%- elif settings.get('timer_target')[:13] == \"media_player.\" %} {{- settings.get('timer_target') }} {%- elif (settings.get('timer_target')[:7] == \"sensor.\" or settings.get('timer_target')[:11] == \"input_text.\") and (states(settings.get('timer_target'))[:13] == \"media_player.\") %} {{- states(settings.get('timer_target')) }} {%- elif (settings.get('timer_target')[:7] == \"sensor.\" or settings.get('timer_target')[:11] == \"input_text.\") and (states(settings.get('timer_target')) == \"\") %} {{- settings.get('timer_target_default') }} {%- else %} {%- set media_player_list = states.media_player | map(attribute='entity_id') | list %} {%- if \"sensor.\" in settings.get('timer_target') or \"input_text.\" in target_area %} {%- set target_area = states(settings.get('timer_target')) %} {%- else %} {%- set target_area = settings.get('timer_target') %} {%- endif %}         {%- for entity_id in media_player_list %} {%- if area_name(entity_id) | lower == target_area | lower %} {{ entity_id }} {%- endif %} {%- endfor %} {%- endif %}  ";
                timer_tts = "{{ settings.get('timer_tts') }}";
                timer_tts_message = "{{ settings.get('timer_tts_message') }}";
                timer_tts_service = "{{ settings.get('timer_tts_service') }}";
                timer_tts_target = "{{ settings.get('timer_tts_target') }}";
                timer_volume = "{{ settings.get('timer_volume') }}";
              };
            }
            {
              alias = "Store current device volume";
              variables = {device_volume = "{{ state_attr(timer_target, 'volume_level') }}";};
            }
            {
              alias = "Set volume for timer";
              data = {volume_level = "{{ timer_volume }}";};
              service = "media_player.volume_set";
              target = {entity_id = "{{ timer_target }}";};
            }
            {
              alias = "Media file or TTS";
              choose = [
                {
                  alias = "Media file";
                  conditions = [
                    {
                      alias = "Timer is a media file";
                      condition = "template";
                      value_template = "{{ timer_tts == false }}";
                    }
                  ];
                  sequence = [
                    {
                      alias = "Play media";
                      data = {
                        announce = true;
                        media_content_id = "{{ timer_media_location }}";
                        media_content_type = "music";
                      };
                      enabled = true;
                      service = "media_player.play_media";
                      target = {entity_id = "{{ timer_target }}";};
                    }
                  ];
                }
              ];
              default = [
                {delay = {seconds = 1;};}
                {
                  alias = "Choose TTS service";
                  choose = [
                    {
                      conditions = [
                        {
                          alias = "tts.cloud_say";
                          condition = "template";
                          value_template = "{{ timer_tts_service != 'tts.speak' }}";
                        }
                      ];
                      sequence = [
                        {
                          data = {
                            cache = true;
                            entity_id = "{{ timer_target }}";
                            message = "{% if timer_tts_message[:7] == \"sensor.\" or timer_tts_message[:11] == \"input_text.\" %} {{ states(timer_tts_message) }} {% else %} {{ timer_tts_message }} {% endif %}";
                          };
                          service = "{{ timer_tts_service }}";
                        }
                      ];
                    }
                  ];
                  default = [
                    {
                      data = {
                        cache = true;
                        media_player_entity_id = "{{ timer_target }}";
                        message = "{% if timer_tts_message[:7] == \"sensor.\" or timer_tts_message[:11] == \"input_text.\" %} {{ states(timer_tts_message) }} {% else %} {{ timer_tts_message }} {% endif %}";
                      };
                      service = "tts.speak";
                      target = {entity_id = "{{ timer_tts_target }}";};
                    }
                  ];
                }
              ];
            }
            {
              alias = "Restore device previous volume";
              data = {volume_level = "{{ device_volume }}";};
              service = "media_player.volume_set";
              target = {entity_id = "{{ timer_target }}";};
            }
          ];
          alias = "Assist - TimerReached";
          condition = [
            {
              alias = "Finished timer is an assist timer";
              condition = "template";
              value_template = "{{ trigger.event.data.entity_id[:18] == 'timer.assist_timer' }}";
            }
          ];
          description = "Assist automation when set timer time is reached.";
          id = "assist_timerreached";
          mode = "single";
          trigger = [
            {
              alias = "Any timer reached";
              event_type = "timer.finished";
              id = "timer_finished";
              platform = "event";
            }
          ];
          variables = {
            inherit settings;
          };
        }
        {
          action = [
            {
              alias = "Delay for Timer Reached automation";
              delay = {seconds = 3;};
            }
            {
              alias = "Reset timer location";
              data = {value = "";};
              service = "input_text.set_value";
              target = {entity_id = "{{ 'input_text.' + trigger.entity_id[6:] + '_location' }}";};
            }
          ];
          alias = "Assist - TimerFinished";
          condition = [
            {
              alias = "Timer was active or paused";
              condition = "template";
              value_template = "{{ trigger.from_state != trigger.to_state }}";
            }
          ];
          description = "Assist automation when set timer time is finished.";
          id = "assist_timerfinished";
          mode = "parallel";
          trigger = [
            {
              alias = "Assist timer finished or cancelled";
              entity_id = ["timer.assist_timer1" "timer.assist_timer2" "timer.assist_timer3"];
              platform = "state";
              to = "idle";
            }
          ];
        }
      ];
      homeassistant = {
        customize = {
          "script.assist_timerstart" = {
            inherit settings;
          };
        };
      };
      input_text = {
        assist_timer1_location = {
          icon = "mdi:assistant";
          max = 255;
          name = "Assist - Timer 1 Location";
        };
        assist_timer2_location = {
          icon = "mdi:assistant";
          max = 255;
          name = "Assist - Timer 2 Location";
        };
        assist_timer3_location = {
          icon = "mdi:assistant";
          max = 255;
          name = "Assist - Timer 3 Location";
        };
      };
      intent_script = {
        TimerDuration = {
          action = [{stop = "";}];
          async_action = true;
        };
        TimerPause = {
          action = [
            {
              data = {
                entity_id = "{{ entity_id }}";
                timer_action = "{{ timer_action }}";
              };
              service = "script.assist_TimerPause";
            }
          ];
          async_action = true;
        };
        TimerStart = {
          action = [
            {
              data = {duration = "{{hours | int(default=0)}}:{{ minutes | int(default=0) }}:{{ seconds | int(default=0) }}";};
              service = "script.assist_TimerStart";
            }
          ];
          async_action = false;
        };
        TimerStop = {
          action = [
            {
              data = {entity_id = "{{ entity_id }}";};
              service = "script.assist_TimerStop";
            }
          ];
          async_action = true;
        };
      };
      script = {
        assist_timerpause = {
          alias = "Assist - TimerPause";
          description = "Script for pausing a timer using HA Assist.";
          icon = "mdi:assistant";
          mode = "single";
          sequence = [
            {
              choose = [
                {
                  conditions = [
                    {
                      alias = "Single Timer";
                      condition = "template";
                      value_template = "{{ entity_id[:18] == 'timer.assist_timer' }}";
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
                              value_template = "{{ states(entity_id) == 'idle' }}";
                            }
                          ];
                          sequence = [{stop = "Timer is not active";}];
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
                                  value_template = "{{ timer_action == 'pause' }}";
                                }
                              ];
                              sequence = [
                                {
                                  alias = "Pause timer";
                                  service = "timer.pause";
                                  target = {entity_id = "{{ entity_id }}";};
                                }
                                {stop = "Pause timer";}
                              ];
                            }
                          ];
                          default = [
                            {
                              alias = "Resume timer";
                              service = "timer.start";
                              target = {entity_id = "{{ entity_id }}";};
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
                      value_template = "{{ entity_id == 'null' }}";
                    }
                    {
                      alias = "Timer(s) are active";
                      condition = "template";
                      value_template = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | list\n   | length > 0 }}";
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
                              value_template = "{{ entity_id == 'null' }}";
                            }
                            {
                              alias = "Multiple timers active";
                              condition = "template";
                              value_template = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | list\n   | length > 1 }}";
                            }
                          ];
                          sequence = [{stop = "Multiple timers active, none specified";}];
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
                                  value_template = "{{ timer_action == 'pause' }}";
                                }
                              ];
                              sequence = [
                                {
                                  alias = "Pause timer";
                                  service = "timer.pause";
                                  target = {entity_id = "{{ states.timer \n | rejectattr('state','eq','idle') \n | selectattr('entity_id','match','timer.assist_timer*')\n | map(attribute='entity_id') \n | join(', ') }}";};
                                }
                                {stop = "Pause timer";}
                              ];
                            }
                          ];
                          default = [
                            {
                              alias = "Resume timer";
                              service = "timer.start";
                              target = {entity_id = "{{ states.timer \n | rejectattr('state','eq','idle') \n | selectattr('entity_id','match','timer.assist_timer*')\n | map(attribute='entity_id') \n | join(', ') }}";};
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
                      value_template = "{{ entity_id == 'all' }}";
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
                              value_template = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | list\n   | length == 0 }}";
                            }
                          ];
                          sequence = [{stop = "No timers active";}];
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
                                  value_template = "{{ timer_action == 'pause' }}";
                                }
                              ];
                              sequence = [
                                {
                                  alias = "Pause timer";
                                  service = "timer.pause";
                                  target = {entity_id = "{{ states.timer \n | rejectattr('state','eq','idle') \n | selectattr('entity_id','match','timer.assist_timer*')\n | map(attribute='entity_id') \n | join(', ') }}";};
                                }
                                {stop = "Pause timer";}
                              ];
                            }
                          ];
                          default = [
                            {
                              alias = "Resume timer";
                              service = "timer.start";
                              target = {entity_id = "{{ states.timer \n | rejectattr('state','eq','idle') \n | selectattr('entity_id','match','timer.assist_timer*')\n | map(attribute='entity_id') \n | join(', ') }}";};
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
          variables = {
            entity_id = "{% if entity_id is set or entity_id != \"\" %} {{ entity_id }} {% else %} null {% endif %}";
            timer_action = "{% if timer_action is set or timer_action != \"\" %} {{ timer_action }} {% else %} resume {% endif %}";
          };
        };
        assist_timerstart = {
          alias = "Assist - TimerStart";
          description = "Script for starting a timer using HA Assist.";
          icon = "mdi:assistant";
          mode = "single";
          sequence = [
            {
              alias = "Set variables";
              variables = {timer_location = "{%- if settings.get('timer_target')[:13] == \"media_player.\" %} {{ area_name(settings.get('timer_target')) | lower }} {% elif (settings.get('timer_target')[:7] == \"sensor.\" or settings.get('timer_target')[:11] == \"input_text.\") and states(settings.get('timer_target'))[:13] == \"media_player.\" %} {{- states(settings.get('timer_target')) }} {%- elif settings.get('timer_target')[:13] != \"media_player.\" and settings.get('timer_target')[:7] != \"sensor.\" and settings.get('timer_target')[:11] != \"input_text.\" %} {{- settings.get('timer_target') }} {%- elif (settings.get('timer_target')[:7] == \"sensor.\" or settings.get('timer_target')[:11] == \"input_text.\") and (states(settings.get('timer_target')) != \"\") and (states(settings.get('timer_target'))[:13] == \"media_player.\") %} {{ area_name(settings.get('timer_target_default')) }} {%- elif (settings.get('timer_target')[:7] == \"sensor.\" or settings.get('timer_target')[:11] == \"input_text.\") %} {% if states(settings.get('timer_target')) != \"\" and states(settings.get('timer_target')) != \"not_home\" and states(settings.get('timer_target')) != 0 %} {{ states(settings.get('timer_target')) }} {% else %} {{- area_name(settings.get('timer_target_default')) | lower }} {%- endif %} {%- else %} {{- area_name(settings.get('timer_target')) | lower }} {%- endif %}";};
            }
            {
              alias = "Set timer location";
              data = {value = "{{ timer_location }}";};
              service = "input_text.set_value";
              target = {entity_id = "{% if states('timer.assist_timer1') != 'active' and states('timer.assist_timer1') != 'paused' %} input_text.assist_timer1_location {% elif states('timer.assist_timer2') != 'active' and states('timer.assist_timer2') != 'paused' %} input_text.assist_timer2_location {% else %} input_text.assist_timer3_location {% endif%}";};
            }
            {
              alias = "Start timer";
              data_template = {duration = "{{ duration }}";};
              service = "timer.start";
              target = {entity_id = "{% if states('timer.assist_timer1') != 'active' and states('timer.assist_timer1') != 'paused' %} timer.assist_timer1 {% elif states('timer.assist_timer2') != 'active' and states('timer.assist_timer2') != 'paused' %} timer.assist_timer2 {% else %} timer.assist_timer3{% endif%}";};
            }
          ];
          variables = {
            inherit settings;
          };
        };
        assist_timerstop = {
          alias = "Assist - TimerStop";
          description = "Script for stopping a timer using HA Assist.";
          icon = "mdi:assistant";
          mode = "single";
          sequence = [
            {
              alias = "Set variables";
              variables = {entity_id = "{% if entity_id is set or entity_id != \"\" %} {{ entity_id }} {% else %} null {% endif %}";};
            }
            {
              choose = [
                {
                  alias = "Stop Timer music";
                  conditions = [
                    {
                      alias = "Timer is a media file";
                      condition = "template";
                      value_template = "{{ timer_tts == false }}";
                    }
                    {
                      condition = "template";
                      value_template = "{% set mediaplayer = namespace(entity=[]) %}\n{% for player in states.media_player %}\n  {%- if ((state_attr(player.entity_id, 'media_content_id') |lower != 'none' and state_attr(player.entity_id, 'media_content_id')[:47][38:] == 'timer.mp3') or state_attr(player.entity_id, 'media_title') | lower == 'timer') and states(player.entity_id) == 'playing' -%}\n    {%- set mediaplayer.entity = player.entity_id -%}\n  {% endif -%}\n{% endfor %}\n{{ mediaplayer.entity[:12] == 'media_player' }}";
                    }
                  ];
                  sequence = [
                    {
                      alias = "Stop timer music";
                      service = "media_player.media_stop";
                      target = {entity_id = "{% set mediaplayer = namespace(entity=[]) %} {% for player in states.media_player %}\n  {% if ((state_attr(player.entity_id, 'media_content_id') |lower != 'none' and state_attr(player.entity_id, 'media_content_id')[:47][38:] == 'timer.mp3') or state_attr(player.entity_id, 'media_title') | lower == 'timer') and states(player.entity_id) == 'playing' %}\n    {% set mediaplayer.entity = player.entity_id %}\n  {% endif %}\n{% endfor %} {{ mediaplayer.entity }}";};
                    }
                  ];
                }
                {
                  conditions = [
                    {
                      alias = "Single Timer";
                      condition = "template";
                      value_template = "{{ entity_id[:18] == 'timer.assist_timer' }}";
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
                              value_template = "{{ states(entity_id) == 'idle' }}";
                            }
                          ];
                          sequence = [{stop = "Timer is not active";}];
                        }
                      ];
                      default = [
                        {
                          alias = "Cancel single timer";
                          service = "timer.cancel";
                          target = {entity_id = "{{ entity_id }}";};
                        }
                        {
                          alias = "Reset timer location value";
                          data = {value = "0";};
                          service = "input_text.set_value";
                          target = {entity_id = "{{ states.timer \n   | selectattr('state','eq','active') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | join('_location, ') | replace('timer.', 'input_text.') }}";};
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
                      value_template = "{{ entity_id == 'null' }}";
                    }
                    {
                      alias = "Timer(s) are active";
                      condition = "template";
                      value_template = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | list\n   | length > 0 }}";
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
                              value_template = "{{ entity_id == 'null' }}";
                            }
                            {
                              alias = "Multiple timers active";
                              condition = "template";
                              value_template = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | list\n   | length > 1 }}";
                            }
                          ];
                          sequence = [{stop = "Multiple timers active, none specified";}];
                        }
                      ];
                      default = [
                        {
                          alias = "Cancel single timer";
                          service = "timer.cancel";
                          target = {entity_id = "{{ states.timer \n | rejectattr('state','eq','idle') \n | selectattr('entity_id','match','timer.assist_timer*')\n | map(attribute='entity_id') \n | join(', ') }}";};
                        }
                        {
                          alias = "Reset timer location value";
                          data = {value = "0";};
                          metadata = {};
                          service = "input_text.set_value";
                          target = {entity_id = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | join('_location, ') | replace('timer.', 'input_text.') }}";};
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
                      value_template = "{{ entity_id == 'all' }}";
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
                              value_template = "{{ states.timer \n   | rejectattr('state','eq','idle') \n   | selectattr('entity_id','match','timer.assist_timer*')\n   | map(attribute='entity_id') \n   | list\n   | length == 0 }}";
                            }
                          ];
                          sequence = [{stop = "No timers active";}];
                        }
                      ];
                      default = [
                        {
                          alias = "Cancel all timers";
                          service = "timer.cancel";
                          target = {entity_id = "{{ states.timer \n | rejectattr('state','eq','idle') \n | selectattr('entity_id','match','timer.assist_timer*')\n | map(attribute='entity_id') \n | join(', ') }}";};
                        }
                        {stop = "Cancel all timers";}
                      ];
                    }
                  ];
                }
              ];
            }
          ];
          variables = {entity_id = "{% if entity_id is set or entity_id != \"\" %} {{ entity_id }} {% else %} null {% endif %}";};
        };
      };
      timer = {
        assist_timer1 = {
          icon = "mdi:assistant";
          name = "Assist - Timer 1";
          restore = true;
        };
        assist_timer2 = {
          icon = "mdi:assistant";
          name = "Assist - Timer 2";
          restore = true;
        };
        assist_timer3 = {
          icon = "mdi:assistant";
          name = "Assist - Timer 3";
          restore = true;
        };
      };
    };
  };
}
