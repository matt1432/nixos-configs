{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.16.0";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-K65kZjLa5AJG9FEYAs/Jf2UC8qiP7BkC8znHMHMYeg4=";
    };
  });
}
