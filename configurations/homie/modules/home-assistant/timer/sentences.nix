{
  language = "en";

  intents = {
    TimerDuration.data = [
      {
        sentences = [
          "how [much] long[er] on [the] {entity_id} timer"
          "how much time is left on [the] {entity_id} timer"
          "how long until [the] {entity_id} timer (is finished|finishes)"
        ];
      }
      {
        sentences = [
          "how [much] long[er] on [the] timer[s]"
          "how much time is left on [the] {entity_id} timer[s]"
          "how long until [the] timer[s] (is finished|finishes)"
        ];
        slots.entity_id = "null";
      }
    ];

    TimerPause.data = [
      {
        sentences = ["(pause|interrupt) [the] {entity_id} timer[s]"];
        slots.timer_action = "pause";
      }
      {
        sentences = ["(pause|interrupt) [the] timer[s]"];
        slots = {
          entity_id = "null";
          timer_action = "pause";
        };
      }
      {
        sentences = ["(pause|interrupt) all timer[s]"];
        slots = {
          entity_id = "all";
          timer_action = "pause";
        };
      }
      {
        sentences = ["(resume|continue) [the] {entity_id} timer[s]"];
        slots.timer_action = "resume";
      }
      {
        sentences = ["(resume|continue) [the] timer[s]"];
        slots = {
          entity_id = "null";
          timer_action = "resume";
        };
      }
      {
        sentences = ["(resume|continue) all timer[s]"];
        slots = {
          entity_id = "all";
          timer_action = "resume";
        };
      }
    ];

    TimerStart.data = [
      {
        sentences = [
          "(start|set) [a] timer (for|with) {hours} hour[s] [and] {minutes} minute[s] [and] {seconds} seconde[s]"
        ];
      }

      {
        sentences = [
          "(start|set) [(a|an)] timer (for|with) {hours} hour[s]"
          "(start|set) [(a|an)] {hours} hour[s] timer"
        ];
        slots = {
          minutes = 0;
          seconds = 0;
        };
      }

      {
        sentences = [
          "(start|set) [a] timer (for|with) {minutes} minute[s]"
          "(start|set) [(a|an)] {minutes} minute[s] timer"
        ];
        slots = {
          hours = 0;
          seconds = 0;
        };
      }

      {
        sentences = [
          "(start|set) [a] timer (for|with) {seconds} seconde[s]"
          "(start|set) [(a|an)] {seconds} second[s] timer"
        ];
        slots = {
          hours = 0;
          minutes = 0;
        };
      }

      {
        sentences = [
          "(start|set) [a] timer (for|with) {minutes} minute[s] [and] {seconds} seconde[s]"
        ];
        slots.hours = 0;
      }

      {
        sentences = [
          "(start|set) [a] timer (for|with) {hours} hour[s] [and] {minutes} minute[s]"
        ];
        slots.seconds = 0;
      }
    ];

    TimerStop.data = [
      {sentences = ["(stop|cancel|turn off) [the] {entity_id} timer[s]"];}
      {
        sentences = ["(stop|cancel|turn off) [the] timer[s]"];
        slots.entity_id = "null";
      }
    ];
  };

  responses.intents = {
    TimerDuration.default = ''
      {%- set timer_amount = states.timer
         | selectattr('state','eq','active')
         | selectattr('entity_id','match','timer.assist_timer*')
         | map(attribute='entity_id')
         | list
         | length -%}

      {% if timer_amount == 0 %}
        There are no timers active.
      {% else %}
        {%- if slots.entity_id != 'all' and slots.entity_id != 'null' %}
          {%- set active_timers = states.timer
            | selectattr('state','eq','active')
            | selectattr('entity_id','match',slots.entity_id)
            | list -%}
        {%- else%}
          {%- set active_timers = states.timer
            | selectattr('state','eq','active')
            | selectattr('entity_id','match','timer.assist_timer*')
            | list -%}
        {%- endif %}

        {% if active_timers|length == 0 %}
          {%- if slots.entity_id != 'all' and slots.entity_id != 'null' %}
            This timer is not active.
          {%- else %}
            There are no timers active.
          {%- endif %}
        {% elif active_timers|length > 1 %}
          There are {{active_timers|length }} timers active.
        {% endif %}

        {% for timer in active_timers %}
          {% set timer_id = timer.entity_id %}
          {% set timer_finishes_at = state_attr(timer_id, 'finishes_at') %}

          {% set time_remaining = as_datetime(timer_finishes_at) - now() %}
          {% set hours_remaining = time_remaining.total_seconds() // 3600 %}
          {% set minutes_remaining = (time_remaining.total_seconds() % 3600) // 60 %}
          {% set seconds_remaining = time_remaining.total_seconds() % 60 %}

          {% if timer.state == "active" or timer.state == "paused" %}
            {% if slots.entity_id != timer_id %}
              {{ state_attr(timer_id, 'friendly_name')[9:] }}

              {% if timer.state == "paused" %}
                is paused and
              {% endif %}
              has
            {% else %}
              There are
            {% endif %}

            {% if hours_remaining > 0 %}
              {{ hours_remaining | round }} hours
            {% endif %}

            {% if minutes_remaining == 1 %}
              1 minute
            {% endif %}

            {% if minutes_remaining > 1 %}
              {{ minutes_remaining | round }} minutes
            {% endif %}

            {% if seconds_remaining == 1 and hours_remaining == 0%}
              1 seconde
            {% endif %}

            {% if seconds_remaining > 1 and hours_remaining == 0 %}
              {{ seconds_remaining | round }} seconds
            {% endif %}
            remaining.
          {% endif %}
        {% endfor %}
      {% endif %}
    '';

    TimerPause.default = ''
      {%- if slots.timer_action is set or slots.timer_action != "" -%}
        {%- set timer_action = slots.timer_action -%}
      {%- else -%}
        {%- set timer_action = "resume" -%}
      {%- endif -%}

      {%- set timer_amount = states.timer
         | selectattr('state','eq','active')
         | selectattr('entity_id','match','timer.assist_timer*')
         | map(attribute='entity_id')
         | list
         | length -%}

      {% if timer_amount == 0 %}
        There are no timers active.

      {% elif timer_amount > 1 and slots.entity_id == 'null' %}
        There are multiple timers active.
        {{ (["Please specify which timer you mean.", "Please specify which timer.", "Specify which timer you mean.", ""] | random) }}

      {% elif slots.entity_id == 'all' %}
        {{ (["Understood. ", "Okay. ", "Of course. ", ""] | random) }}.
        All timers
        {% if timer_action == "pause" %}
          paused
        {% else %}
          resumed
        {% endif %}
        .

      {% elif (as_timestamp(now()) - as_timestamp(states.timer.assist_timer1.last_changed) < 3 and states('timer.assist_timer1') == 'idle') or
              (as_timestamp(now()) - as_timestamp(states.timer.assist_timer2.last_changed) < 3 and states('timer.assist_timer2') == 'idle') or
              (as_timestamp(now()) - as_timestamp(states.timer.assist_timer3.last_changed) < 3 and states('timer.assist_timer3') == 'idle') %}
        Timer
        {% if timer_action == "pause" %}
          paused
        {% else %}
          resumed
        {% endif %}
        .

      {% elif (timer_amount == 1 and slots.entity_id == 'null') or
         (slots.entity_id == 'timer.assist_timer1' and states('timer.assist_timer1') != 'idle') or
         (slots.entity_id == 'timer.assist_timer2' and states('timer.assist_timer2') != 'idle') or
         (slots.entity_id == 'timer.assist_timer3' and states('timer.assist_timer3') != 'idle') %}
        {{ (["Understood. ", "Okay. ", "Of course. ", ""] | random) }}Timer
        {% if timer_action == "pause" %}
          paused
        {% else %}
          resumed
        {% endif %}
        .
      {% else %}

        This timer is not active.
      {% endif %}
    '';

    TimerStart.default = ''
      {{ (["Understood. ", "Okay. ", "Of course. ", ""] | random) +
        (["I will start a timer for ", "Timer started with ", "Starting timer with ", "Timer active for "] | random)}}

      {% if (slots.hours | int(default=0)) == 1 %}
        1 hour
      {% elif (slots.hours | int(default=0)) > 1 %}
        {{ (slots.hours | int)}} hours
      {% endif %}

      {% if (slots.hours | int(default=0)) > 0 and ((slots.minutes | int(default=0)) > 0 or (slots.seconds | int(default=0)) > 0) %}
        and
      {% endif %}

      {% if (slots.minutes | int(default=0)) == 1 %}
        1 minute
      {% elif (slots.minutes | int(default=0)) > 1 %}
        {{ (slots.minutes | int)}} minutes
      {% endif %}

      {% if (slots.minutes | int(default=0)) > 0 and (slots.seconds | int(default=0)) > 0 %}
        and
      {% endif %}

      {% if (slots.seconds | int(default=0)) == 1 %}
        1 second
      {% elif (slots.seconds | int(default=0)) > 1 %}
        {{ (slots.seconds | int)}} secondes
      {% endif %}.
    '';

    TimerStop.default = ''
      {%- set timer_amount = states.timer
            | selectattr('state','eq','active')
            | selectattr('entity_id','match','timer.assist_timer*')
            | map(attribute='entity_id')
            | list
            | length -%}

      {% set mediaplayer = namespace(entity=[]) %}

      {% for player in states.media_player %}
        {%- if ((state_attr(player.entity_id, 'media_content_id') | lower != 'none'
            and state_attr(player.entity_id, 'media_content_id')[:47][38:] == 'Timer.mp3')
            or state_attr(player.entity_id, 'media_title') | lower == 'timer')
            and states(player.entity_id) == 'playing' -%}
          {%- set mediaplayer.entity = player.entity_id -%}
        {% endif -%}
      {% endfor %}

      {% if mediaplayer.entity[:12] == 'media_player' %}
        {{ (["Understood. ", "Okay. ", "Of course. ", ""] | random) }}Timer stopped.
      {% elif timer_amount == 0 and
           (as_timestamp(now()) - as_timestamp(states.timer.assist_timer1.last_changed) > 3 and states('timer.assist_timer1') == 'idle') and
           (as_timestamp(now()) - as_timestamp(states.timer.assist_timer2.last_changed) > 3 and states('timer.assist_timer2') == 'idle') and
           (as_timestamp(now()) - as_timestamp(states.timer.assist_timer3.last_changed) > 3 and states('timer.assist_timer3') == 'idle') %}
        There are no timers active.
      {% elif (slots_entity_id == 'timer.assist_timer1' and states('timer.assist_timer1') == 'idle') or
           (slots_entity_id == 'timer.assist_timer2' and states('timer.assist_timer2') == 'idle') or
           (slots_entity_id == 'timer.assist_timer3' and states('timer.assist_timer3') == 'idle') %}
        This timer is not active.
      {% elif timer_amount > 1 and slots_entity_id == 'null' %}
        There are multiple timers active.
        {{ (["Please specify which timer you mean.", "Please specify which timer.", "Specify which timer you mean.", ""] | random) }}
      {% elif slots_entity_id == 'all' %}
        {{ (["Understood. ", "Okay. ", "Of course. ", ""] | random) }}All timers stopped.
      {% else %}
        {{ (["Understood. ", "Okay. ", "Of course. ", ""] | random) }}Timer stopped.
      {% endif %}
    '';
  };

  lists = {
    entity_id.values = [
      {
        "in" = "(first|one|1)";
        out = "timer.assist_timer1";
      }
      {
        "in" = "(second|two|2)";
        out = "timer.assist_timer2";
      }
      {
        "in" = "(third|three|3)";
        out = "timer.assist_timer3";
      }
      {
        "in" = "(all|every)";
        out = "all";
      }
    ];

    hours.values = [
      {
        "in" = "(one|1)";
        out = 1;
      }
      {
        "in" = "(two|2)";
        out = 2;
      }
      {
        "in" = "(three|3)";
        out = 3;
      }
      {
        "in" = "(four|4)";
        out = 4;
      }
      {
        "in" = "(five|5)";
        out = 5;
      }
      {
        "in" = "(six|6)";
        out = 6;
      }
      {
        "in" = "(seven|7)";
        out = 7;
      }
      {
        "in" = "(eight|8)";
        out = 8;
      }
      {
        "in" = "(nine|9)";
        out = 9;
      }
      {
        "in" = "(ten|10)";
        out = 10;
      }
      {
        "in" = "(eleven|11)";
        out = 11;
      }
      {
        "in" = "(twelve|12)";
        out = 12;
      }
      {
        "in" = "(thirteen|13)";
        out = 13;
      }
      {
        "in" = "(fourteen|14)";
        out = 14;
      }
      {
        "in" = "(fifteen|15)";
        out = 15;
      }
      {
        "in" = "(sixteen|16)";
        out = 16;
      }
      {
        "in" = "(seventeen|17)";
        out = 17;
      }
      {
        "in" = "(eighteen|18)";
        out = 18;
      }
      {
        "in" = "(nineteen|19)";
        out = 19;
      }
      {
        "in" = "(twenty|20)";
        out = 20;
      }
      {
        "in" = "(twenty-one|21)";
        out = 21;
      }
      {
        "in" = "(twenty-two|22)";
        out = 22;
      }
      {
        "in" = "(twenty-three|23)";
        out = 23;
      }
      {
        "in" = "(twenty-four|24)";
        out = 24;
      }
    ];

    minutes.values = [
      {
        "in" = "(one|1)";
        out = 1;
      }
      {
        "in" = "(two|2)";
        out = 2;
      }
      {
        "in" = "(three|3)";
        out = 3;
      }
      {
        "in" = "(four|4)";
        out = 4;
      }
      {
        "in" = "(five|5)";
        out = 5;
      }
      {
        "in" = "(six|6)";
        out = 6;
      }
      {
        "in" = "(seven|7)";
        out = 7;
      }
      {
        "in" = "(eight|8)";
        out = 8;
      }
      {
        "in" = "(nine|9)";
        out = 9;
      }
      {
        "in" = "(ten|10)";
        out = 10;
      }
      {
        "in" = "(eleven|11)";
        out = 11;
      }
      {
        "in" = "(twelve|12)";
        out = 12;
      }
      {
        "in" = "(thirteen|13)";
        out = 13;
      }
      {
        "in" = "(fourteen|14)";
        out = 14;
      }
      {
        "in" = "(fifteen|15)";
        out = 15;
      }
      {
        "in" = "(sixteen|16)";
        out = 16;
      }
      {
        "in" = "(seventeen|17)";
        out = 17;
      }
      {
        "in" = "(eighteen|18)";
        out = 18;
      }
      {
        "in" = "(nineteen|19)";
        out = 19;
      }
      {
        "in" = "(twenty|20)";
        out = 20;
      }
      {
        "in" = "(twenty-one|21)";
        out = 21;
      }
      {
        "in" = "(twenty-two|22)";
        out = 22;
      }
      {
        "in" = "(twenty-three|23)";
        out = 23;
      }
      {
        "in" = "(twenty-four|24)";
        out = 24;
      }
      {
        "in" = "(twenty-five|25)";
        out = 25;
      }
      {
        "in" = "(twenty-six|26)";
        out = 26;
      }
      {
        "in" = "(twenty-seven|27)";
        out = 27;
      }
      {
        "in" = "(twenty-eight|28)";
        out = 28;
      }
      {
        "in" = "(twenty-nine|29)";
        out = 29;
      }
      {
        "in" = "(thirty|30)";
        out = 30;
      }
      {
        "in" = "(thirty-one|31)";
        out = 31;
      }
      {
        "in" = "(thirty-two|32)";
        out = 32;
      }
      {
        "in" = "(thirty-three|33)";
        out = 33;
      }
      {
        "in" = "(thirty-four|34)";
        out = 34;
      }
      {
        "in" = "(thirty-five|35)";
        out = 35;
      }
      {
        "in" = "(thirty-six|36)";
        out = 36;
      }
      {
        "in" = "(thirty-seven|37)";
        out = 37;
      }
      {
        "in" = "(thirty-eight|38)";
        out = 38;
      }
      {
        "in" = "(thirty-nine|39)";
        out = 39;
      }
      {
        "in" = "(forty|40)";
        out = 40;
      }
      {
        "in" = "(forty-one|41)";
        out = 41;
      }
      {
        "in" = "(forty-two|42)";
        out = 42;
      }
      {
        "in" = "(forty-three|43)";
        out = 43;
      }
      {
        "in" = "(forty-four|44)";
        out = 44;
      }
      {
        "in" = "(forty-five|45)";
        out = 45;
      }
      {
        "in" = "(forty-six|46)";
        out = 46;
      }
      {
        "in" = "(forty-seven|47)";
        out = 47;
      }
      {
        "in" = "(forty-eight|48)";
        out = 48;
      }
      {
        "in" = "(forty-nine|49)";
        out = 49;
      }
      {
        "in" = "(fifty|50)";
        out = 50;
      }
      {
        "in" = "(fifty-one|51)";
        out = 51;
      }
      {
        "in" = "(fifty-two|52)";
        out = 52;
      }
      {
        "in" = "(fifty-three|53)";
        out = 53;
      }
      {
        "in" = "(fifty-four|54)";
        out = 54;
      }
      {
        "in" = "(fifty-five|55)";
        out = 55;
      }
      {
        "in" = "(fifty-six|56)";
        out = 56;
      }
      {
        "in" = "(fifty-seven|57)";
        out = 57;
      }
      {
        "in" = "(fifty-eight|58)";
        out = 58;
      }
      {
        "in" = "(fifty-nine|59)";
        out = 59;
      }
      {
        "in" = "(sixty|60)";
        out = 60;
      }
    ];

    seconds.values = [
      {
        "in" = "(one|1)";
        out = 1;
      }
      {
        "in" = "(two|2)";
        out = 2;
      }
      {
        "in" = "(three|3)";
        out = 3;
      }
      {
        "in" = "(four|4)";
        out = 4;
      }
      {
        "in" = "(five|5)";
        out = 5;
      }
      {
        "in" = "(six|6)";
        out = 6;
      }
      {
        "in" = "(seven|7)";
        out = 7;
      }
      {
        "in" = "(eight|8)";
        out = 8;
      }
      {
        "in" = "(nine|9)";
        out = 9;
      }
      {
        "in" = "(ten|10)";
        out = 10;
      }
      {
        "in" = "(eleven|11)";
        out = 11;
      }
      {
        "in" = "(twelve|12)";
        out = 12;
      }
      {
        "in" = "(thirteen|13)";
        out = 13;
      }
      {
        "in" = "(fourteen|14)";
        out = 14;
      }
      {
        "in" = "(fifteen|15)";
        out = 15;
      }
      {
        "in" = "(sixteen|16)";
        out = 16;
      }
      {
        "in" = "(seventeen|17)";
        out = 17;
      }
      {
        "in" = "(eighteen|18)";
        out = 18;
      }
      {
        "in" = "(nineteen|19)";
        out = 19;
      }
      {
        "in" = "(twenty|20)";
        out = 20;
      }
      {
        "in" = "(twenty-one|21)";
        out = 21;
      }
      {
        "in" = "(twenty-two|22)";
        out = 22;
      }
      {
        "in" = "(twenty-three|23)";
        out = 23;
      }
      {
        "in" = "(twenty-four|24)";
        out = 24;
      }
      {
        "in" = "(twenty-five|25)";
        out = 25;
      }
      {
        "in" = "(twenty-six|26)";
        out = 26;
      }
      {
        "in" = "(twenty-seven|27)";
        out = 27;
      }
      {
        "in" = "(twenty-eight|28)";
        out = 28;
      }
      {
        "in" = "(twenty-nine|29)";
        out = 29;
      }
      {
        "in" = "(thirty|30)";
        out = 30;
      }
      {
        "in" = "(thirty-one|31)";
        out = 31;
      }
      {
        "in" = "(thirty-two|32)";
        out = 32;
      }
      {
        "in" = "(thirty-three|33)";
        out = 33;
      }
      {
        "in" = "(thirty-four|34)";
        out = 34;
      }
      {
        "in" = "(thirty-five|35)";
        out = 35;
      }
      {
        "in" = "(thirty-six|36)";
        out = 36;
      }
      {
        "in" = "(thirty-seven|37)";
        out = 37;
      }
      {
        "in" = "(thirty-eight|38)";
        out = 38;
      }
      {
        "in" = "(thirty-nine|39)";
        out = 39;
      }
      {
        "in" = "(forty|40)";
        out = 40;
      }
      {
        "in" = "(forty-one|41)";
        out = 41;
      }
      {
        "in" = "(forty-two|42)";
        out = 42;
      }
      {
        "in" = "(forty-three|43)";
        out = 43;
      }
      {
        "in" = "(forty-four|44)";
        out = 44;
      }
      {
        "in" = "(forty-five|45)";
        out = 45;
      }
      {
        "in" = "(forty-six|46)";
        out = 46;
      }
      {
        "in" = "(forty-seven|47)";
        out = 47;
      }
      {
        "in" = "(forty-eight|48)";
        out = 48;
      }
      {
        "in" = "(forty-nine|49)";
        out = 49;
      }
      {
        "in" = "(fifty|50)";
        out = 50;
      }
      {
        "in" = "(fifty-one|51)";
        out = 51;
      }
      {
        "in" = "(fifty-two|52)";
        out = 52;
      }
      {
        "in" = "(fifty-three|53)";
        out = 53;
      }
      {
        "in" = "(fifty-four|54)";
        out = 54;
      }
      {
        "in" = "(fifty-five|55)";
        out = 55;
      }
      {
        "in" = "(fifty-six|56)";
        out = 56;
      }
      {
        "in" = "(fifty-seven|57)";
        out = 57;
      }
      {
        "in" = "(fifty-eight|58)";
        out = 58;
      }
      {
        "in" = "(fifty-nine|59)";
        out = 59;
      }
      {
        "in" = "(sixty|60)";
        out = 60;
      }
    ];
  };
}
