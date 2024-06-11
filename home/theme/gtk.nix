{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.vars) fontSize;
  inherit (import ./gradience.nix {inherit pkgs lib;}) gradience;
in {
  home.packages = with pkgs; [
    gnomeExtensions.user-themes
  ];

  # Gtk settings
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Flat-Remix-Violet-Dark";
      package = pkgs.flat-remix-icon-theme;
    };

    font = {
      name = "Sans Serif";
      size = fontSize;
    };

    gtk3 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
      };
      extraCss = "@import url(\"file://${gradience.build}/gtk-3.0/gtk.css\");";
    };

    gtk4 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
      };
      extraCss = "@import url(\"file://${gradience.build}/gtk-4.0/gtk.css\");";
    };
  };

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = gradience.shellTheme;
    };
    "org/gnome/shell" = {
      enabled-extensions = [pkgs.gnomeExtensions.user-themes.extensionUuid];
    };
  };

  xdg.dataFile.shellTheme = {
    enable = true;
    recursive = true;
    source = "${gradience.build}/gradience-shell";
    target = "themes/${gradience.shellTheme}";
  };
}
