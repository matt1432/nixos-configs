{
  # nix build inputs
  lib,
  libratbag-src,
  # deps
  libratbag,
  ...
}: let
  inherit (lib) elemAt match readFile splitString;

  releaseVer = elemAt (match "^([^']*).*" (elemAt (splitString "version : '" (readFile "${libratbag-src}/meson.build")) 1)) 0;
in
  libratbag.overrideAttrs {
    pname = "libratbag";
    version = "${releaseVer}+${libratbag-src.shortRev}";
    src = libratbag-src;
  }
