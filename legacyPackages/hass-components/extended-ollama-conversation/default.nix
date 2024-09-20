{
  extended-ollama-conversation-src,
  buildHomeAssistantComponent,
  openai,
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${extended-ollama-conversation-src}/custom_components/extended_ollama_conversation/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "TheNimaj";

    inherit (manifest) domain version;

    src = extended-ollama-conversation-src;

    propagatedBuildInputs = [
      python3Packages.ollama
      openai
    ];
  }
