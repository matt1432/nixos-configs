{
  lib,
  self,
  stdenvNoCC,
}: let
  inherit (builtins) fromJSON readFile;
  inherit (lib) hasPrefix replaceStrings;

  inherit (self.inputs) firefox-gx-src;
  inherit (self.lib) mkVersion;

  lock = fromJSON (readFile ../../../flake.lock);
  rev =
    lock.nodes.firefox-gx-src.original.ref
    or lock.nodes.firefox-gx-src.original.rev;
in
  stdenvNoCC.mkDerivation {
    pname = "firefox-gx";
    version =
      if hasPrefix "v." rev
      then replaceStrings ["v"] ["0"] rev
      else mkVersion firefox-gx-src;

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
