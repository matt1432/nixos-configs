{
  bat-theme-src,
  gtk-theme-src,
  xresources-theme-src,
  ...
} @ inputs: (final: prev: {
  dracula-theme = prev.dracula-theme.overrideAttrs (oldAttrs: let
    git-colors = prev.callPackage ./git.nix inputs;
    plymouth = prev.callPackage ./plymouth.nix inputs;
    wallpaper = prev.fetchurl (import ./wallpaper.nix);
  in {
    version = gtk-theme-src.shortRev;
    src = gtk-theme-src;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plymouth/themes $out/wallpapers
      cp -a ${wallpaper} $out/wallpapers/waves.png

      cp -a ${bat-theme-src}/Dracula.tmTheme $out/bat
      cp -a ${git-colors}/git-colors $out/git-colors
      cp -a ${plymouth}/share/plymouth/themes/dracula $out/share/plymouth/themes/
      cp -a ${xresources-theme-src}/Xresources $out/xres

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
