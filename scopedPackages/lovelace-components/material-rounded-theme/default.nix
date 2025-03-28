{
  # nix build inputs
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "3.1.2";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-Kx0kbDAaWDD5ttcCjZDLElSUpfyNYvHxFHXB2Dd7ba0=";
    };

    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail \
          "git branch --show-current" "echo main"
    '';

    npmDepsHash = "sha256-hjAXWC+vOb93WiGLCvDMRO3FXgSRUq8ikSpCEjFxBN0=";

    installPhase = ''
      mkdir $out
      cp ./dist/* $out
    '';

    meta = {
      license = lib.licenses.asl20;
      homepage = "https://github.com/Nerwyn/material-rounded-theme";
      description = ''
        Material Design 3 Colors and Components in Home Assistant.
      '';
    };
  }
