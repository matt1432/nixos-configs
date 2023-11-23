{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  writeText,
}: let
  pname = "firefox-gx";
  version = "8.6";

  custom-menu = writeText "menu" "${builtins.readFile ./ogx_menu.css}";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Godiesc";
      repo = pname;
      rev = "v.${version}";
      sha256 = "sha256-AaufMjeK66y/3ymz7TkiIgvtmAvD/pjou7+wVglUFGc=";
    };

    installPhase = ''
      # Personal changes
      sed -i 's/var(--fuchsia))/var(--purple))/' ./chrome/components/ogx_root-personal.css

      # Fix new tab background for nix
      substituteInPlace ./chrome/components/ogx_root-personal.css \
        --replace '../images/newtab/wallpaper-dark.png' "$out/chrome/images/newtab/private-dark.png"

      # TODO: make patch instead
      # FIXME: menu is bugged again
      cp -a ${custom-menu} ./chrome/components/ogx_menu.css

      mkdir -p $out
      cp -r ./* $out
    '';

    meta = with lib; {
      description = "Firefox Theme CSS to Opera GX Lovers ";
      homepage = "https://github.com/Godiesc/firefox-gx";
      license = licenses.mspl;
    };
  }
