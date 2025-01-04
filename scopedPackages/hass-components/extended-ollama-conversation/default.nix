{
  extended-ollama-conversation-src,
  buildHomeAssistantComponent,
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

    prePatch = ''
      substituteInPlace ./custom_components/extended_ollama_conversation/manifest.json \
          --replace-warn "ollama~=0.3.0" "ollama>=0.3.0"
    '';

    propagatedBuildInputs = with python3Packages; [
      ollama
      openai
    ];
  }
