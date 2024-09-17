# I use nix2yaml from ../default.nix to convert to to YAML and place it in the functions of extended_ollama_conversation
[
  {
    function = {
      name = "execute_service";
      type = "native";
    };

    spec = {
      name = "execute_services";
      description = "Use this function to execute service of devices in Home Assistant.";

      parameters = {
        type = "object";

        properties.list = {
          type = "array";

          items = {
            type = "object";

            properties = {
              entity_id = {
                description = "The entity_id retrieved from available devices. It must start with domain, followed by dot character.";
                type = "string";
              };

              service = {
                description = "The service to be called";
                type = "string";
              };
            };

            required = ["entity_id" "service"];
          };
        };
      };
    };
  }

  {
    function = {
      type = "script";

      sequence = [
        {
          service = "script.assist_TimerStart";

          data.duration = builtins.concatStringsSep "" [
            ''{% if not hours %} {% set hours = "0" %} {% endif %}''
            ''{% if not minutes %} {% set minutes = "0" %} {% endif %}''
            ''{% if not seconds %} {% set seconds = "0" %} {% endif %}''

            ''{{ hours | int(default=0) }}:{{ minutes | int(default=0) }}:{{ seconds | int(default=0) }}''
          ];

          target.entity_id = "timer.assist_timer1";
        }
      ];
    };

    spec = {
      name = "timer_start";
      description = "Use this function to start a timer in Home Assistant.";

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
  }
]
