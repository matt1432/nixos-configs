{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}: let
  pname = "firefox-gx";
  version = "c1d9888d27543ded51f9854d7e58db601fd33d43";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Godiesc";
      repo = pname;
      rev = "${version}";
      sha256 = "sha256-lMco3TYQNVTQEF5TpKiHUbexdB5pD3OmqjACD2BJZaY=";
    };

    installPhase = ''
      # Personal changes
      sed -i 's/var(--fuchsia))/var(--purple))/' ./chrome/components/ogx_root-personal.css

      # Fix new tab background for nix
      substituteInPlace ./chrome/components/ogx_root-personal.css \
        --replace '../images/newtab/wallpaper-dark.png' "$out/chrome/images/newtab/private-dark.png"

      mkdir -p $out
      cp -r ./* $out
    '';

    meta = with lib; {
      description = "Firefox Theme CSS to Opera GX Lovers";
      homepage = "https://github.com/Godiesc/firefox-gx";
      license = licenses.mspl;
    };
  }
