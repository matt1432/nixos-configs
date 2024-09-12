{
  buildHomeAssistantComponent,
  home-llm-src,
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${home-llm-src}/custom_components/llama_conversation/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "acon96";

    inherit (manifest) domain version;

    src = home-llm-src;

    # FIXME: remove this on next release https://github.com/acon96/home-llm/issues/214
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
