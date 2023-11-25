{
  lib,
  pkgs,
  config,
  ...
}: let
  optionals = lib.lists.optionals;
  isNvidia = config.hardware.nvidia.modesetting.enable;
  user = config.services.device-vars.username;

  hyprBin = "${config.home-manager.users.${user}
    .wayland.windowManager.hyprland.finalPackage}/bin";
  regreetBin = "${lib.getExe config.programs.regreet.package}";

  style = pkgs.writeText "style.css" ''${builtins.readFile ./style.css}'';

  setupMonitors = pkgs.writeShellScriptBin "setupMonitors" ''
    names=($(${hyprBin}/hyprctl -j monitors | ${pkgs.jq}/bin/jq -r '.[] .name'))

    for (( i=1; i<''${#names[@]}; i++ )); do
        ${hyprBin}/hyprctl keyword monitor ''${names[$i]},preferred,auto,1,mirror,''${names[0]}
    done
  '';

  hyprConf =
    pkgs.writeText "greetd-hypr-config"
    (lib.strings.concatStrings ((optionals isNvidia [
        "env = LIBVA_DRIVER_NAME,nvidia\n"
        "env = XDG_SESSION_TYPE,wayland\n"
        "env = GBM_BACKEND,nvidia-drm\n"
        "env = __GLX_VENDOR_LIBRARY_NAME,nvidia\n"
        "env = WLR_NO_HARDWARE_CURSORS,1\n"
      ])
      ++ [
        "exec-once = ${setupMonitors}/bin/setupMonitors &&"
        "    swww init --no-cache &&"
        "    swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png\n"

        "${builtins.readFile ./hyprland.conf}\n"

        "exec-once = ${regreetBin} -s ${style};"
        "    ${hyprBin}/hyprctl dispatch exit"
      ]));
in {
  users.users.greeter = {
    packages = with pkgs; [
      dracula-theme
      flat-remix-icon-theme
      swww
      gtk3
      glib
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
