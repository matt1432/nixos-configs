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
          [Appearance]
          color_scheme_path=/home/matt/.config/qt6ct/style-colors.conf
          custom_palette=true
          standard_dialogs=xdgdesktopportal
          style=kvantum-dark
          icon_theme=Flat-Remix-Violet-Dark

          [Fonts]
          fixed="Noto Nerd Font,${floatFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
          general="Noto Nerd Font,${floatFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

          [Interface]
          activate_item_on_single_click=1
          buttonbox_layout=0
          cursor_flash_time=1000
          dialog_buttons_have_icons=1
          double_click_interval=400
          gui_effects=@Invalid()
          keyboard_scheme=2
          menus_have_icons=true
          show_shortcuts_in_context_menus=true
          stylesheets=@Invalid()
          toolbutton_style=4
          underline_shortcut=1
          wheel_scroll_lines=3

          [SettingsWindow]
          geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\vh\0\0\au\0\0\r\x8b\0\0\0\0\0\0\vh\0\0\au\0\0\r\x8b\0\0\0\0\x2\0\0\0\a\x80\0\0\0\0\0\0\vh\0\0\au\0\0\r\x8b)

          [Troubleshooting]
          force_raster_widgets=1
          ignored_applications=@Invalid()
      '';

      qtStyleColors =
        # ini
        ''
          [ColorScheme]
          active_colors=#fff8f8f2, #ff1e1e20, #ff0c0e15, #ff0c0e15, #ff0c0e15, #ff0c0e15, #fff8f8f2, #ffffffff, #fff8f8f2, #ff1e1f29, #ff1e1f29, #ff000000, #ff7c60a3, #ffdadadc, #ff646464, #ff7f8c8d, #78252a3f, #ff000000, #ff000000, #fff8f8f2, #80f8f8f2, #ff308cc6
          disabled_colors=#ffbebebe, #ffefefef, #ffffffff, #ffcacaca, #ffbebebe, #ffb8b8b8, #ffbebebe, #ffffffff, #ffbebebe, #ffefefef, #ffefefef, #ffb1b1b1, #ff919191, #ffffffff, #ff0000ff, #ffff00ff, #fff7f7f7, #ff000000, #ffffffdc, #ff000000, #80000000, #ff919191
          inactive_colors=#fff8f8f2, #ff1e1e20, #ff0c0e15, #ff0c0e15, #ff0c0e15, #ff0c0e15, #fff8f8f2, #ffffffff, #fff8f8f2, #ff1e1f29, #ff1e1f29, #ff000000, #ff7c60a3, #ffdadadc, #ff646464, #ff7f8c8d, #78252a3f, #ff000000, #ff000000, #fff8f8f2, #80f8f8f2, #ff308cc6
        '';
    in {
      "Kvantum/Dracula/Dracula.kvconfig".source = "${dracula.gtk}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
      "Kvantum/Dracula/Dracula.svg".source = "${dracula.gtk}/share/Kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";

      "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";

      "qt5ct/qt5ct.conf".text = qtconf;
      "qt6ct/qt6ct.conf".text = qtconf;
      "qt6ct/style-colors.conf".text = qtStyleColors;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
