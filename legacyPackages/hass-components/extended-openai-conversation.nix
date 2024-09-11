{
  extended-openai-conversation-src,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python312Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${extended-openai-conversation-src}/custom_components/extended_openai_conversation/manifest.json");

  openai = python312Packages.openai.overrideAttrs (o: rec {
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
    owner = "jekalmin";

    inherit (manifest) domain version;

    src = extended-openai-conversation-src;

    propagatedBuildInputs = [openai];
  }
