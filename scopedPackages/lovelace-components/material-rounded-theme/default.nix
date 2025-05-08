{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "4.0.5";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-9q93FyRFISKaDLnSDCF1gn/pJnzGk3QNelY6w8Oba1k=";
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
