final: prev: {
  dracula-theme = prev.dracula-theme.overrideAttrs (oldAttrs: rec {

    plymouth = prev.fetchFromGitHub {
      owner = "dracula";
      repo = "plymouth";
      rev = "37aa09b27ecee4a825b43d2c1d20b502e8f19c96";
      hash = "sha256-7YwkBzkAND9lfH2ewuwna1zUkQStBBx4JHGw3/+svhA=";
    };

    git-colors = prev.fetchFromGitHub {
      owner = "dracula";
      repo = "git";
      rev = "924d5fc32f7ca15d0dd3a8d2cf1747e81e063c73";
      hash = "sha256-3tKjKn5IHIByj+xgi2AIL1vZANlb0vlYJsPjH6BHGxM=";
    };

    wallpaper = prev.fetchurl {
      url = "https://github.com/aynp/dracula-wallpapers/blob/main/Art/4k/Waves%201.png?raw=true";
      hash = "sha256-f9FwSOSvqTeDj4bOjYUQ6TM+/carCD9o5dhg/MnP/lk=";
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

      # Git colors
      cp -a ${git-colors}/config/gitconfig ./git-colors
      chmod 777 ./git-colors

      line=$(grep -n 'Dracula Dark Theme' ./git-colors | cut -d: -f1)
      sed -i "1,$((line-1))d" ./git-colors

      mkdir -p $out
      cp -a ./git-colors $out

      # Plymouth
      cp -a ${plymouth}/dracula ./dracula
      chmod 777 ./dracula

      sed -i "s@\/usr\/@$out\/@" ./dracula/dracula.plymouth

      mkdir -p $out/share/plymouth/themes
      cp -a ./dracula $out/share/plymouth/themes/

      # Wallpapers
      cp -a ${wallpaper} ./waves.png

      mkdir -p $out/wallpapers
      cp -a ./waves.png $out/wallpapers/


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
}