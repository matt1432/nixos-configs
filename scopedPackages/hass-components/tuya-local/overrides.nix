{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.17.0";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-Pm1bhORJj/7j8Dt03FlRe2Dnw0+vb7FqEKe51voLNvE=";
    };
  });
}
