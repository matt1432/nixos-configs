{
  # nix build inputs
  buildHomeAssistantComponent,
  extended-ollama-conversation-src,
  # deps
  ollama,
  openai,
  ...
}: let
  inherit (builtins) fromJSON readFile;
  manifest = fromJSON (readFile "${extended-ollama-conversation-src}/custom_components/extended_ollama_conversation/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "TheNimaj";

    inherit (manifest) domain version;
    src = extended-ollama-conversation-src;

    dependencies = [
      ollama
      openai
    ];

    ignoreVersionRequirement = ["ollama"];

    meta = {
      homepage = "https://github.com/TheNimaj/extended_ollama_conversation";
      description = ''
        Home Assistant custom component of conversation agent. It uses Ollama to control your devices.
      '';
    };
  }
