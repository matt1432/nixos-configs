{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.vars) fontSize;
in {
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 24;

    gtk.enable = true;

    x11 = {
      enable = true;
      defaultCursor = "Dracula-cursors";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      name = "Flat-Remix-Violet-Dark";
      package = pkgs.flat-remix-icon-theme;
    };

    font = {
      name = "Sans Serif";
      size = fontSize;
    };
  };

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];
  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  xresources.extraConfig =
    builtins.readFile
    "${pkgs.dracula-theme}/xres";

  xdg.configFile = let
    floatFont = lib.strings.floatToString fontSize;
    qtconf =
      /*
      ini
      */
      ''
        [Fonts]
        fixed="Sans Serif,${floatFont},-1,5,50,0,0,0,0,0"
        general="Sans Serif,${floatFont},-1,5,50,0,0,0,0,0"

        [Appearance]
        icon_theme=Flat-Remix-Violet-Dark
        style='';
    # The newline before this must be there
  in {
    "Kvantum/Dracula/Dracula.kvconfig".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
    "Kvantum/Dracula/Dracula.svg".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";

    "qt5ct/qt5ct.conf".text = qtconf + "kvantum";
    "qt6ct/qt6ct.conf".text = qtconf + "kvantum";
  };
}
