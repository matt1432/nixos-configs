{
  extended-ollama-conversation-src,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${extended-ollama-conversation-src}/custom_components/extended_ollama_conversation/manifest.json");

  openai = python3Packages.openai.overrideAttrs (o: rec {
    version = "1.3.8";

    src = fetchFromGitHub {
      owner = "openai";
      repo = "openai-python";
      rev = "refs/tags/v${version}";
      hash = "sha256-yU0XWEDYl/oBPpYNFg256H0Hn5AaJiP0vOQhbRLnAxQ=";
    };

    disabledTests = o.disabledTests ++ ["test_retrying_timeout_errors_doesnt_leak" "test_retrying_status_errors_doesnt_leak"];
  });
in
  buildHomeAssistantComponent {
    owner = "TheNimaj";

    inherit (manifest) domain version;

    src = extended-ollama-conversation-src;

    propagatedBuildInputs = [python3Packages.ollama openai];
  }
