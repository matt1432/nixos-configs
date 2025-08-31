{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.17.4";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-ojwopholSQPND246PJMmEFSdzyXEZjAIgzpIRfS3VBw=";
    };
  });
}
