{
  buildHomeAssistantComponent,
  home-llm-src,
  python3Packages,
  ...
}: let
  manifest = builtins.fromJSON (builtins.readFile "${home-llm-src}/custom_components/llama_conversation/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "acon96";

    inherit (manifest) domain version;

    src = home-llm-src;

    postPatch = ''
      substituteInPlace ./custom_components/llama_conversation/manifest.json \
          --replace-warn "huggingface-hub==0.23.0" "huggingface-hub>=0.23.0" \
          --replace-warn "webcolors<=1.13" "webcolors>=1.13"
    '';

    propagatedBuildInputs = with python3Packages; [
      huggingface-hub
      requests
      webcolors
    ];
  }
