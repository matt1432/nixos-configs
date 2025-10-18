self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (pkgs.scopedPackages) dracula;

  inherit (lib) getExe mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.kdePackages.qtstyleplugin-kvantum
    ];

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "qtct";
    };

    home.activation = let
      setupOkularThemeScript = getExe (pkgs.writeShellApplication {
        name = "setupOkularThemeScript";
        text = ''
          if [[ -f "$HOME/.config/okularrc" ]]; then
              exit 0
          fi

          cat <<EOF > "$HOME/.config/okularrc"
          [Desktop Entry]
          FullScreen=false
          shouldShowMenuBarComingFromFullScreen=true
          shouldShowToolBarComingFromFullScreen=true

          [General]
          LockSidebar=true
          ShowSidebar=false

          [UiSettings]
          ColorScheme=LavandaDark
          EOF
        '';
      });
    in {
      setupOkularTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ${setupOkularThemeScript}
      '';
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
  };

  # For accurate stack trace
  _file = ./default.nix;
}
