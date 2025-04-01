{
  # nix build inputs
  python3Packages,
  Kapowarr-src,
  ...
}: let
  pyPkgs = python3Packages.override {
    overrides = pyFinal: pyPrev: {
      bencoding = pyFinal.callPackage ./bencoding {};
      typing-extensions = pyFinal.callPackage ./typing-extensions {};
    };
  };
in
  pyPkgs.callPackage ./kapowarr {inherit Kapowarr-src;}
