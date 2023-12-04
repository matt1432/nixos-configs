{
  pkgs,
  lib,
  config,
  ...
}: let
  dracula-xresources = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "539ef24e9b0c5498a82d59bfa2bad9b618d832a3";
    sha256 = "sha256-6fltsAluqOqYIh2NX0I/LC3WCWkb9Fn8PH6LNLBQbrY=";
  };
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
      size = config.vars.fontSize;
    };
  };

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum #FIXME: doesn't work with qt6ct
  ];
  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  xresources.extraConfig = builtins.readFile "${dracula-xresources}/Xresources";

  xdg.configFile = let
    qtconf = ''
      [Fonts]
      fixed="Sans Serif,${lib.strings.floatToString config.vars.fontSize},-1,5,50,0,0,0,0,0"
      general="Sans Serif,${lib.strings.floatToString config.vars.fontSize},-1,5,50,0,0,0,0,0"

      [Appearance]
      icon_theme=Flat-Remix-Violet-Dark
      style='';
  in {
    "Kvantum/Dracula/Dracula.kvconfig".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
    "Kvantum/Dracula/Dracula.svg".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";

    "qt5ct/qt5ct.conf".text = qtconf + "kvantum";
  };
}
