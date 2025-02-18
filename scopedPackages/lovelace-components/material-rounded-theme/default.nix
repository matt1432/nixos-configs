{
  # nix build inputs
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "3.0.8";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-Ao+ogzLXWH5Kfix8KeOr8FPXmjCFkwKqKz5Jp1XbpD0=";
    };

    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail \
          "git branch --show-current" "echo main"
    '';

    npmDepsHash = "sha256-P9IrXMaRsOY2QEBAuV8X15QGonImvLj2MaIED5GzwuA=";

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
