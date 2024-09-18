# I use nix2yaml from ../default.nix to convert this to YAML and place it in the functions of extended_ollama_conversation
let
  inherit (import ../../../../../lib {}) lib;
  inherit (lib) concatStrings concatStringsSep splitString;
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
            duration = concatStrings [
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

  {
    spec = {
      name = "timer_duration";
      description = "Use this function to get the remaining duration of a timer in Home Assistant.";

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
      type = "template";

      value_template = concatStringsSep " " (splitString "\n" ''
        {%- set entity_id = "timer.assist_timer" ~ timer_number %}

        {%- set timer_amount = states.timer
          | selectattr("state","eq","active")
          | selectattr("entity_id","match","timer.assist_timer*")
          | map(attribute="entity_id")
          | list
          | length -%}

        {% if timer_amount == 0 %}
        There are no timers active.

        {% else %}
          {%- if entity_id != "all" and entity_id != "null" %}
            {%- set active_timers = states.timer
              | selectattr("state","eq","active")
              | selectattr("entity_id","match",entity_id)
              | list -%}

          {%- else%}
            {%- set active_timers = states.timer
              | selectattr("state","eq","active")
              | selectattr("entity_id","match","timer.assist_timer*")
              | list -%}
          {%- endif %}

          {% if active_timers|length == 0 %}
            {%- if entity_id != "all" and entity_id != "null" %}
              This timer is not active.

            {%- else %}
              There are no timers active.
            {%- endif %}

          {% elif active_timers | length > 1 %}
            There are {{active_timers|length }} timers active.
          {% endif %}

          {% for timer in active_timers %}
            {% set timer_id = timer.entity_id %}
            {% set timer_finishes_at = state_attr(timer_id, "finishes_at") %}
            {% set time_remaining = as_datetime(timer_finishes_at) - now() %}
            {% set hours_remaining = time_remaining.total_seconds() // 3600 %}
            {% set minutes_remaining = (time_remaining.total_seconds() % 3600) // 60 %}
            {% set seconds_remaining = time_remaining.total_seconds() % 60 %}

            {% if timer.state == "active" or timer.state == "paused" %}
              {% if entity_id != timer_id %}
                {{ state_attr(timer_id, "friendly_name")[9:] }} {% if timer.state == "paused" %} is paused and {% endif %} has

              {% else %}
               There are
              {% endif %}

              {% if hours_remaining > 0 %}{{ hours_remaining | round }} hours {% endif %}
              {% if minutes_remaining == 1 %}1 minute {% endif %}
              {% if minutes_remaining > 1 %}{{ minutes_remaining | round }} minutes {% endif %}
              {% if seconds_remaining == 1 and hours_remaining == 0%}1 seconde {% endif %}
              {% if seconds_remaining > 1 and hours_remaining == 0 %}{{ seconds_remaining | round }} seconds {% endif %}remaining.
            {% endif %}
          {% endfor %}
        {% endif %}
      '');
    };
  }
]
