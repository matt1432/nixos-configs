{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}: let
  pname = "protonhax";
  version = "1.0.5";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "jcnils";
      repo = "protonhax";
      rev = version;
      hash = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
    };

    installPhase = ''
      install -Dt $out/bin -m755 protonhax
    '';

    meta = {
      license = with lib.licenses; [bsd3];
      homepage = "https://github.com/jcnils/protonhax";
      description = ''
        Tool to help running other programs (i.e. Cheat Engine) inside Steam's proton.
      '';
    };
  }
