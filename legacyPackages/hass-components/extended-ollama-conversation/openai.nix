pkgs:
pkgs.python3Packages.openai.overrideAttrs (o: rec {
  name = "${o.pname}-${version}";
  version = "1.3.8";

  src = pkgs.fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-yU0XWEDYl/oBPpYNFg256H0Hn5AaJiP0vOQhbRLnAxQ=";
  };

  disabledTests =
    o.disabledTests
    ++ [
      "test_retrying_timeout_errors_doesnt_leak"
      "test_retrying_status_errors_doesnt_leak"
    ];
})
