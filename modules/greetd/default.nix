{ lib
, pkgs
, config
, hyprland
, ...
}: let
  regreetBin = "${lib.getExe config.programs.regreet.package}";
  hyprBin = "${hyprland.packages.x86_64-linux.default}/bin";
  gset = pkgs.gsettings-desktop-schemas;

  css = pkgs.writeText "style.css" ''${builtins.readFile ./style.css}'';

  paperConf = pkgs.writeText "hyprpaper.conf" ''
    preload = ${pkgs.dracula-theme}/wallpapers/waves.png
    wallpaper = eDP-1, ${pkgs.dracula-theme}/wallpapers/waves.png
  '';

  hyprConf = pkgs.writeText "greetd-hypr-config" ''
    exec-once = hyprpaper --config ${paperConf}

    ${builtins.readFile ./hyprland.conf}

    # FIXME: kb doesn't work
    env = XDG_DATA_DIRS, ${gset}/share/gsettings-schemas/${gset.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
    exec-once = squeekboard
    exec-once = gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

    exec-once = ${regreetBin} -s ${css}; ${hyprBin}/hyprctl dispatch exit
  '';
in {
  users.users.greeter = {
    packages = with pkgs; [
      dracula-theme
      flat-remix-icon-theme
      hyprpaper
      gtk3
      glib
      squeekboard
    ];
  };

  # See overlay
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        cursor_theme_name = "Dracula-cursors";
        font_name = "Sans Serif";
        icon_theme_name = "Flat-Remix-Violet-Dark";
        theme_name = "Dracula";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${hyprBin}/Hyprland --config ${hyprConf}";
        user = "greeter";
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
