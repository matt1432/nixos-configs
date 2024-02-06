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

  hyprland = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;
  ags = config.home-manager.users.${mainUser}.programs.ags.package;

  # Show Regreet on all monitors
  dupeMonitors = pkgs.writeShellApplication {
    name = "dupeMonitors";
    runtimeInputs = [hyprland pkgs.jq];
    text = ''
      main="${mainMonitor}"
      names="($(hyprctl -j monitors | jq -r '.[] .description'))"

      if [[ "$main" == "null" ]]; then
          main="''${names[0]}"
      fi

      for (( i=0; i<''${#names[@]}; i++ )); do

          # shellcheck disable=SC2001
          name=$(echo "''${names[$i]}" | sed 's/.*(\(.*\))/\1/')
          # shellcheck disable=SC2001
          desc=$(echo "''${names[$i]}" | sed 's/ (.*//')

          if [[ "$name" != "$main" && "desc:$desc" != "$main" ]]; then
              hyprctl keyword monitor "$name",preferred,auto,1,mirror,"$main"
          fi
      done
    '';
  };

  # Check if user wants the greeter only on main monitor
  setupMonitors =
    if (mainMonitor != "null" && !greetdDupe)
    then "hyprctl dispatch focusmonitor ${mainMonitor}"
    else "dupeMonitors";

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
        "exec-once = ${setupMonitors} && sleep 0.1 &&"
        "    swww init --no-cache &&"
        "    swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png\n"

        "${readFile ./hyprland.conf}\n"

        "exec-once = ags -b greeter; hyprctl dispatch exit"
      ]));
in {
  # Add home folder for home-manager to work
  users.users.greeter = {
    home = "/var/lib/greeter";
    createHome = true;
  };

  home-manager.users.greeter = {
    imports = [
      ../../common/vars
      ../../home/theme.nix
    ];

    home = {
      packages = [
        hyprland
        ags
        dupeMonitors
        pkgs.bun
        pkgs.sassc
        pkgs.swww
        pkgs.gtk3
        pkgs.glib
      ];

      file = {
        ".config/ags" = {
          source = ../ags/config;
          recursive = true;
        };

        ".config/ags/config.js".text =
          /*
          javascript
          */
          ''
            import { transpileTypeScript } from './js/utils.js';

            export default (await transpileTypeScript('greeter')).default;
          '';
      };
    };

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
          command = "Hyprland --config ${hyprConf}";
          user = "greeter";
        };

        initial_session = {
          command = "Hyprland";
          user = mainUser;
        };
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
