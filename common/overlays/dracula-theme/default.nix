(final: prev: {
  dracula-theme = prev.dracula-theme.overrideAttrs (oldAttrs: let
    bat-colors = prev.callPackage ./bat.nix prev;
    git-colors = prev.callPackage ./git.nix prev;
    plymouth = prev.callPackage ./plymouth.nix prev;
    wallpaper = prev.callPackage ./wallpaper.nix prev;
    Xresources = prev.callPackage ./xresources.nix prev;
  in {
    src = prev.fetchFromGitHub {
      owner = "dracula";
      repo = "gtk";
      rev = "84dd7a3021938ceec8a0ee292a8561f8a6d47ebe";
      hash = "sha256-xHf+f0RGMtbprJX+3c0cmp5LKkf0V7BHKcoiAW60du8=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plymouth/themes

      cp -a ${bat-colors}/bat $out/bat
      cp -a ${git-colors}/git-colors $out/git-colors
      cp -a ${plymouth}/share/plymouth/themes/dracula $out/share/plymouth/themes/
      cp -a ${wallpaper}/wallpapers $out/wallpapers
      cp -a ${Xresources}/xres $out/xres

      # -------------------------------------------
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
})
