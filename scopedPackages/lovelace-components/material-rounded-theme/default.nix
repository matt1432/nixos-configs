{
  # nix build inputs
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "3.1.4";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-I5vV6HkKUvoWQFZulnpAcR4NBkqKwhN39/HhkBK0qoU=";
    };

    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail \
          "git branch --show-current" "echo main"
    '';

    npmDepsHash = "sha256-yNQnWoX9touEfwBRM7y+QAkyOKm24h58HU8MEmTIOZg=";

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
