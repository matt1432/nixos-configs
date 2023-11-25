{
  lib,
  pkgs,
  config,
  ...
}: let
  user = config.services.device-vars.username;
  hyprBin = "${config.home-manager.users.${user}.wayland.windowManager.hyprland.finalPackage}/bin";

  nvidia =
    if config.hardware.nvidia.modesetting.enable
    then {
      env = ''
        env = LIBVA_DRIVER_NAME,nvidia
        env = XDG_SESSION_TYPE,wayland
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = WLR_NO_HARDWARE_CURSORS,1
      '';
    }
    else {
      env = "";
    };
  regreetBin = "${lib.getExe config.programs.regreet.package}";
  gset = pkgs.gsettings-desktop-schemas;

  css = pkgs.writeText "style.css" ''${builtins.readFile ./style.css}'';

  hyprConf = pkgs.writeText "greetd-hypr-config" ''
    exec-once = swww init --no-cache && swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png

    ${builtins.readFile ./hyprland.conf}

    ${nvidia.env}

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
      swww
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
