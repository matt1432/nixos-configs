{
  lib,
  pkgs,
  config,
  ...
}: let
  # Nix stuff
  optionals = lib.lists.optionals;
  isNvidia = config.hardware.nvidia.modesetting.enable;
  vars = config.services.device-vars;

  # Executables' paths
  regreetBin = "${lib.getExe config.programs.regreet.package}";
  hyprBin = "${config.home-manager.users.${vars.username}
    .wayland.windowManager.hyprland.finalPackage}/bin";

  # Show Regreet on all monitors
  dupeMonitors = pkgs.writeShellScriptBin "dupeMonitors" ''
    names=($(${hyprBin}/hyprctl -j monitors | ${pkgs.jq}/bin/jq -r '.[] .name'))
    main="${vars.mainMonitor}"

    if [[ $(echo "$main") == "null" ]]; then
        main="''${names[0]}"
    fi

    for (( i=0; i<''${#names[@]}; i++ )); do
        if [[ ''${names[$i]} != "$main" ]]; then
          ${hyprBin}/hyprctl keyword monitor ''${names[$i]},preferred,auto,1,mirror,"$main"
        fi
    done
  '';

  # Check if user wants Regreet only on main monitor
  setupMonitors = if vars.mainMonitor != null && !vars.greetdDupe
    then "${hyprBin}/hyprctl dispatch focusmonitor ${vars.mainMonitor}"
    else "${dupeMonitors}/bin/dupeMonitors";

  # Get css for regreet
  style = pkgs.writeText "style.css" ''${builtins.readFile ./style.css}'';

  # Setup Hyprland as regreet's compositor
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
        "exec-once = ${setupMonitors} &&"
        "    sleep 1; swww init --no-cache &&"
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
