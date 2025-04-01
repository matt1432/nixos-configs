{
  # nix build inputs
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "3.1.5";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-NvIAwuvy5SGs35ScmODXDwSrFdtRvYUhrzzI5WRH1WQ=";
    };

    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail \
          "git branch --show-current" "echo main"
    '';

    npmDepsHash = "sha256-Ph+qIViLVTfVDJPnO7wlYdLTRY8CwXayTqkdKDAt/ac=";

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
