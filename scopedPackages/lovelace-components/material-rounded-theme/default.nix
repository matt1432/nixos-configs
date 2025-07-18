{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "4.0.9";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-iM6DAqkkObaMRLyoVXMnMOoVc+AeCqmSuqUlfUGrg4A=";
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
