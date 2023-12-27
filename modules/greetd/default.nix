{
  lib,
  pkgs,
  config,
  ...
}: with lib; let
  # Nix stuff
  isNvidia = config.hardware.nvidia.modesetting.enable;
  isTouchscreen = config.hardware.sensor.iio.enable;

  hyprland =
    config
    .home-manager
    .users
    .${config.vars.user}
    .wayland
    .windowManager
    .hyprland
    .finalPackage;
  # Executables' paths
  hyprBin = "${hyprland}/bin";
  regreetBin = "${getExe config.programs.regreet.package}";

  # Show Regreet on all monitors
  dupeMonitors = pkgs.writeShellScriptBin "dupeMonitors" ''
    main="${config.vars.mainMonitor}"
    names=($(${hyprBin}/hyprctl -j monitors | ${pkgs.jq}/bin/jq -r '.[] .description'))

    if [[ "$main" == "null" ]]; then
        main="''${names[0]}"
    fi

    for (( i=0; i<''${#names[@]}; i++ )); do

        name=$(echo "''${names[$i]}" | sed 's/.*(\(.*\))/\1/')
        desc=$(echo "''${names[$i]}" | sed 's/ (.*//')

        if [[ "$name" != "$main" && "desc:$desc" != "$main" ]]; then
          ${hyprBin}/hyprctl keyword monitor "$name",preferred,auto,1,mirror,"$main"
        fi
    done
  '';

  # Check if user wants Regreet only on main monitor
  setupMonitors =
    if (config.vars.mainMonitor != "null" && !config.vars.greetdDupe)
    then "${hyprBin}/hyprctl dispatch focusmonitor ${config.vars.mainMonitor}"
    else "${dupeMonitors}/bin/dupeMonitors";

  # Get css for regreet
  style = pkgs.writeText "style.css" ''${readFile ./style.css}'';

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

        "${readFile ./hyprland.conf}\n"

        "exec-once = ${regreetBin} -s ${style};"
        "    ${hyprBin}/hyprctl dispatch exit"
      ]));
in {
  imports = [./regreet.nix];

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

  services = {
    xserver = {
      displayManager = {
        sessionPackages = [hyprland];
      };

      libinput.enable = true;
      wacom.enable = isTouchscreen;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${hyprBin}/Hyprland --config ${hyprConf}";
          user = "greeter";
        };

        initial_session = {
          command = "${hyprBin}/Hyprland";
          user = config.vars.user;
        };
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
