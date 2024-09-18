# I use nix2yaml from ../default.nix to convert this to YAML and place it in the functions of extended_ollama_conversation
let
  inherit (builtins) concatStringsSep;
in [
  {
    spec = {
      name = "timer_start";
      description = "Use this function to start a timer in Home Assistant whose ID defaults to 1.";

      parameters = {
        type = "object";

        properties = {
          hours = {
            type = "string";
            description = "The amount of hours the timer should run for.";
          };

          minutes = {
            type = "string";
            description = "The amount of minutes the timer should run for.";
          };

          seconds = {
            type = "string";
            description = "The amount of seconds the timer should run for.";
          };
        };

        required = [];
      };
    };

    function = {
      type = "script";

      sequence = [
        {
          service = "script.assist_timerstart";

          # dummy ID that won't be used by the script
          target.entity_id = "timer.assist_timer1";

          data = {
            duration = concatStringsSep "" [
              ''{% if not hours %} {% set hours = "0" %} {% endif %}''
              ''{% if not minutes %} {% set minutes = "0" %} {% endif %}''
              ''{% if not seconds %} {% set seconds = "0" %} {% endif %}''

              ''{{ hours | int(default=0) }}:{{ minutes | int(default=0) }}:{{ seconds | int(default=0) }}''
            ];
          };
        }
      ];
    };
  }

  {
    spec = {
      name = "timer_stop";
      description = "Use this function to stop a timer in Home Assistant.";

      parameters = {
        type = "object";

        properties = {
          timer_number = {
            type = "string";
            description = "The number of the timer";
            enum = ["1" "2" "3"];
          };
        };

        required = ["timer_number"];
      };
    };

    function = {
      type = "script";

      sequence = [
        {
          service = "script.assist_timerstop";
          target.entity_id = ''{{ "timer.assist_timer" ~ timer_number }}'';
        }
      ];
    };
  }

  {
    spec = {
      name = "timer_pause";
      description = "Use this function to pause a timer in Home Assistant.";

      parameters = {
        type = "object";

        properties = {
          timer_number = {
            type = "string";
            description = "The number of the timer";
            enum = ["1" "2" "3"];
          };
        };

        required = ["timer_number"];
      };
    };

    function = {
      type = "script";

      sequence = [
        {
          service = "script.assist_timerpause";

          target.entity_id = ''{{ "timer.assist_timer" ~ timer_number }}'';

          data = {
            timer_action = "pause";
          };
        }
      ];
    };
  }

  {
    spec = {
      name = "timer_unpause";
      description = "Use this function to unpause or resume a timer in Home Assistant.";

      parameters = {
        type = "object";

        properties = {
          timer_number = {
            type = "string";
            description = "The number of the timer";
            enum = ["1" "2" "3"];
          };
        };

        required = ["timer_number"];
      };
    };

    function = {
      type = "script";

      sequence = [
        {
          service = "script.assist_timerpause";

          target.entity_id = ''{{ "timer.assist_timer" ~ timer_number }}'';

          data = {
            timer_action = "resume";
          };
        }
      ];
    };
  }

  /*
  TimerDuration:
    async_action: true
    action:
      - stop: ""
  */
]
