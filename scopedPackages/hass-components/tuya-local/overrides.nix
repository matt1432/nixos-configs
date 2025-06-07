{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.17.2";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-x6ZfpT3ucby95uthHX4KLLZNLWxyh6+ERDd5jb7p09g=";
    };
  });
}
