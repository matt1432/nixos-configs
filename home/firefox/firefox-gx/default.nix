{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  writeText,
}: let
  pname = "firefox-gx";
  version = "8.5";

  custom-menu = writeText "menu" "${builtins.readFile ./ogx_menu.css}";
  custom-sidebar = writeText "sidebar" "${builtins.readFile ./ogx_left-sidebar.css}";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Godiesc";
      repo = pname;
      rev = "v.${version}";
      sha256 = "sha256-llffq16PZz5GxkLIJDeWN1d04SCCJFqwCLzOrxgwhYI=";
    };

    installPhase = ''
      # Personal changes
      sed -i 's/var(--fuchsia))/var(--purple))/' ./chrome/components/ogx_root-personal.css

      # Fix new tab background for nix
      substituteInPlace ./chrome/components/ogx_root-personal.css \
        --replace '../images/newtab/wallpaper-dark.png' "$out/chrome/images/newtab/private-dark.png"

      # TODO: make patch instead
      cp -a ${custom-menu} ./chrome/components/ogx_menu.css
      cp -a ${custom-sidebar} ./chrome/components/ogx_left-sidebar.css

      mkdir -p $out
      cp -r ./* $out
    '';

    meta = with lib; {
      description = "Firefox Theme CSS to Opera GX Lovers ";
      homepage = "https://github.com/Godiesc/firefox-gx";
      license = licenses.mspl;
    };
  }
