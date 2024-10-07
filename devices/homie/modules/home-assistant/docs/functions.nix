# I use nix2yaml from ../default.nix to convert this to YAML and place it in the functions of extended_ollama_conversation
[
  {
    spec = {
      name = "get_attributes";
      description = "Get attributes of any home assistant entity";
      parameters = {
        type = "object";

        properties = {
          entity_id = {
            type = "string";
            description = "entity_id";
          };
        };

        required = ["entity_id"];
      };
    };

    function = {
      type = "template";
      value_template = "{{ states[entity_id] }}";
    };
  }
]
