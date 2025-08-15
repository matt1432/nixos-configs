{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.17.3";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-6VhfNIz/A9YT85VqnBbFmyUOHDNjSlLB6GNb+m/HhIg=";
    };
  });
}
