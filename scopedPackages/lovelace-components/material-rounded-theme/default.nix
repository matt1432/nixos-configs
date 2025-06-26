{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "4.0.8";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-6qnt7WZkh392V1hUypkqpxSLGHDDLiTd4Rh2BzUOmt0=";
    };

    installPhase = ''
      mkdir -p $out/share
      cp ./src/material_you.yaml $out/share
    '';

    meta = {
      license = lib.licenses.asl20;
      homepage = "https://github.com/Nerwyn/material-rounded-theme";
      description = ''
        Material Design 3 Colors and Components in Home Assistant.
      '';
    };
  }
