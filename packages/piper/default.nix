{
  lib,
  piper-src,
  piper,
  ...
}: let
  inherit (lib) elemAt match readFile splitString;

  releaseVer = elemAt (match "^([^']*).*" (elemAt (splitString "version: '" (readFile "${piper-src}/meson.build")) 1)) 0;
in
  piper.overrideAttrs rec {
    pname = "piper";
    version = "${releaseVer}+${piper-src.shortRev}";

    name = "${pname}-${version}";

    src = piper-src;

    mesonFlags = [
      "-Druntime-dependency-checks=false"
    ];
  }
