{
  # nix build inputs
  buildHomeAssistantComponent,
  extended-ollama-conversation-src,
  # deps
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

    meta = {
      homepage = "https://github.com/TheNimaj/extended_ollama_conversation";
      description = ''
        Home Assistant custom component of conversation agent. It uses Ollama to control your devices.
      '';
    };
  }
