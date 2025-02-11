{
  # nix build inputs
  lib,
  piper-src,
  # deps
  piper,
  ...
}: let
  inherit (lib) elemAt match readFile splitString;

  releaseVer = elemAt (match "^([^']*).*" (elemAt (splitString "version: '" (readFile "${piper-src}/meson.build")) 1)) 0;
in
  piper.overridePythonAttrs {
    pname = "piper";
    version = "${releaseVer}+${piper-src.shortRev}";

    src = piper-src;

    mesonFlags = [
      "-Druntime-dependency-checks=false"
    ];
  }
