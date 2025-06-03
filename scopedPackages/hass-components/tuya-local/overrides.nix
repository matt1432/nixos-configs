{pkgs, ...}: python3Packages: final: prev: {
  tinytuya = prev.tinytuya.overridePythonAttrs (o: rec {
    version = "1.17.1";
    src = pkgs.fetchFromGitHub {
      owner = "jasonacox";
      repo = "tinytuya";
      rev = "v${version}";
      hash = "sha256-ivtd61r68kUP/OOIkdTjVI5FiD7QsYe6eSr2WiVF7OI=";
    };
  });
}
