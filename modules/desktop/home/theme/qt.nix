{
  lib,
  osConfig,
  pkgs,
  self,
  ...
}: let
  inherit (self.legacyPackages.${pkgs.system}) dracula;

  cfg = osConfig.roles.desktop;
in {
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  xdg.configFile = let
    floatFont = lib.strings.floatToString cfg.fontSize;
    qtconf =
      # ini
      ''
        [Fonts]
        fixed="Sans Serif,${floatFont},-1,5,50,0,0,0,0,0"
        general="Sans Serif,${floatFont},-1,5,50,0,0,0,0,0"

        [Appearance]
        icon_theme=Flat-Remix-Violet-Dark
        style='';
    # The newline before this must be there
  in {
    "Kvantum/Dracula/Dracula.kvconfig".source = "${dracula.gtk}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
    "Kvantum/Dracula/Dracula.svg".source = "${dracula.gtk}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";

    "qt5ct/qt5ct.conf".text = qtconf + "kvantum";
    "qt6ct/qt6ct.conf".text = qtconf + "kvantum";
  };
}
