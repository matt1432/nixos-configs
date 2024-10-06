/*
This package uses a `wyoming-openwakeword` fork that makes use of
the upstream `openwakeword` instead of a fork: https://github.com/rhasspy/wyoming-openwakeword/pull/27
*/
pkgs: let
  pyPkgs = pkgs.python312Packages;

  speexdsp-ns = pkgs.callPackage ./speexdsp-ns.nix {
    python3Packages = pyPkgs;
  };

  openwakeword = pkgs.callPackage ./openwakeword.nix {
    inherit speexdsp-ns;
    python3Packages = pyPkgs;
  };
in
  (pkgs.wyoming-openwakeword.override {
    python3Packages = pyPkgs;
  })
  .overrideAttrs (o: {
    src = pkgs.fetchFromGitHub {
      owner = "rhasspy";
      repo = "wyoming-openwakeword";
      rev = "synesthesiam-20240627-openwakeword";
      hash = "sha256-69oR2LHiUfx8j39nWp7XhG5xTvmOoPCLjSlH1CFvavo=";
    };

    propagatedBuildInputs = [openwakeword pyPkgs.wyoming];
  })
