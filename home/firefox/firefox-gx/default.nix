{
  lib,
  stdenvNoCC,
  firefox-gx-src,
}:
stdenvNoCC.mkDerivation {
  pname = "firefox-gx";
  version = firefox-gx-src.shortRev;

  src = firefox-gx-src;

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
