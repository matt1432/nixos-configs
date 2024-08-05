{
  lib,
  mkVersion,
  firefox-gx-src,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "firefox-gx";
  version = mkVersion firefox-gx-src;

  src = firefox-gx-src;

  installPhase = ''
    # Personal changes
    sed -i 's/var(--fuchsia))/var(--purple))/' ./chrome/components/ogx_root-personal.css
    sed -i 's#../newtab/wallpaper-dark1.png#../newtab/wallpaper-dark2.png#' ./chrome/components/ogx_root-personal.css

    mkdir -p $out
    cp -r ./* $out
  '';

  meta = {
    description = "Firefox Theme CSS to Opera GX Lovers";
    homepage = "https://github.com/Godiesc/firefox-gx";
    license = lib.licenses.mspl;
  };
}
