{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.16.1";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-+ReTNPKMYUXNA5tu7kZM8/7Bh4XjHSjZTiW8ROHkk5M=";
    };
  });
}
