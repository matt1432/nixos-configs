{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "firefox-gx";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "Godiesc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FCx5mADqrjAN27lLaZViOFGUNDg/2jpern8sem8u49w=";
  };

  installPhase = ''
    # Personal changes
    sed -i 's/var(--fuchsia))/var(--purple))/' ./chrome/components/ogx_root-personal.css

    # Fix new tab background for nix
    substituteInPlace ./chrome/components/ogx_root-personal.css \
      --replace-fail '../newtab/wallpaper-dark.png' "$out/chrome/newtab/private-dark.png"

    mkdir -p $out
    cp -r ./* $out
  '';

  meta = with lib; {
    description = "Firefox Theme CSS to Opera GX Lovers";
    homepage = "https://github.com/Godiesc/firefox-gx";
    license = licenses.mspl;
  };
}
