{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) optionals readFile;
  inherit (config.vars) mainUser greetdDupe mainMonitor;

  # Nix stuff
  isNvidia = config.hardware.nvidia.modesetting.enable;
  isTouchscreen = config.hardware.sensor.iio.enable;

  hyprland =
    config
    .home-manager
    .users
    .${mainUser}
    .wayland
    .windowManager
    .hyprland
    .finalPackage;
  hyprBin = "${hyprland}/bin";

  ags = config.home-manager.users.${mainUser}.programs.ags.package;
  agsBin = "${ags}/bin";

  # Show Regreet on all monitors
  dupeMonitors = pkgs.writeShellScriptBin "dupeMonitors" ''
    main="${mainMonitor}"
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

  # Check if user wants the greeter only on main monitor
  setupMonitors =
    if (mainMonitor != "null" && !greetdDupe)
    then "${hyprBin}/hyprctl dispatch focusmonitor ${mainMonitor}"
    else "${dupeMonitors}/bin/dupeMonitors";

  # Setup Hyprland as the greeter's compositor
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
        "    swww init --no-cache &&"
        "    swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png\n"

        "${readFile ./hyprland.conf}\n"

        "exec-once = ${agsBin}/ags --config ${./greetd.js};"
        "    ${hyprBin}/hyprctl dispatch exit"
      ]));
in {
  # Add home folder for home-manager to work
  users.users.greeter.home = "/var/lib/greetd";

  home-manager.users.greeter = {
    imports = [
      ../../common/vars
      ../../home/theme.nix
    ];

    home.packages = with pkgs; [
      swww
      gtk3
      glib
    ];

    vars = config.vars;
    home.stateVersion = "24.05";
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
          user = mainUser;
        };
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
