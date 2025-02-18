{
  # nix build inputs
  lib,
  stdenv,
  fetchurl,
  ...
}: let
  pname = "big-slider-card";
  version = "1.1.5";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/nicufarmache/lovelace-big-slider-card/releases/download/${version}/${pname}.js";
      hash = "sha256-uNlgsiubLXG1VzhNCSeKo/5TmQF1fzFHjTYfutEXn1M=";
    };

    phases = ["installPhase"];

    installPhase = ''
      mkdir $out
      cp $src $out/${pname}.js
    '';

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/nicufarmache/lovelace-big-slider-card";
      description = ''
        A card with a big slider for light entities in Home Assistant.
      '';
    };
  }
