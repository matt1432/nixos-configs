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

    # FIXME: https://github.com/acon96/home-llm/issues/214
    postPatch = ''
      substituteInPlace ./custom_components/llama_conversation/manifest.json \
          --replace-warn "huggingface-hub==0.23.0" "huggingface-hub>=0.23.0"
    '';

    propagatedBuildInputs = with python3Packages; [
      huggingface-hub
      requests
      webcolors
    ];
  }
