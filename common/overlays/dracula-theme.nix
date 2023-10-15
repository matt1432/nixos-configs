final: prev: {
  dracula-theme = prev.dracula-theme.overrideAttrs (oldAttrs: rec {

    plymouth = prev.fetchFromGitHub {
      owner = "dracula";
      repo = "plymouth";
      rev = "37aa09b27ecee4a825b43d2c1d20b502e8f19c96";
      hash = "sha256-7YwkBzkAND9lfH2ewuwna1zUkQStBBx4JHGw3/+svhA=";
    };

    src = prev.fetchFromGitHub {
      owner = "dracula";
      repo = "gtk";
      rev = "84dd7a3021938ceec8a0ee292a8561f8a6d47ebe";
      hash = "sha256-xHf+f0RGMtbprJX+3c0cmp5LKkf0V7BHKcoiAW60du8=";
    };

    preInstallPhase = ''
    '';

    installPhase = ''
      runHook preInstall

      cp -a ${plymouth}/dracula ./dracula
      chmod 777 ./dracula
      sed -i "s@\/usr\/@$out\/@" ./dracula/dracula.plymouth

      mkdir -p $out/share/plymouth/themes
      cp -a ./dracula $out/share/plymouth/themes/

      mkdir -p $out/share/themes/Dracula
      cp -a {assets,cinnamon,gnome-shell,gtk-2.0,gtk-3.0,gtk-3.20,gtk-4.0,index.theme,metacity-1,unity,xfwm4} $out/share/themes/Dracula

      cp -a kde/{color-schemes,plasma} $out/share/
      cp -a kde/kvantum $out/share/Kvantum

      mkdir -p $out/share/aurorae/themes
      cp -a kde/aurorae/* $out/share/aurorae/themes/

      mkdir -p $out/share/sddm/themes
      cp -a kde/sddm/* $out/share/sddm/themes/

      mkdir -p $out/share/icons/Dracula-cursors
      mv kde/cursors/Dracula-cursors/index.theme $out/share/icons/Dracula-cursors/cursor.theme
      mv kde/cursors/Dracula-cursors/cursors $out/share/icons/Dracula-cursors/cursors

      runHook postInstall
    '';
  });
}
