# Unfortunately I had some hardware issues but this does work
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce getExe;

  connectControllers = getExe (pkgs.writeShellApplication {
    name = "connectControllers";
    runtimeInputs = with pkgs; [gnugrep usbutils];
    text = ''
      set +o errexit

      for dev in /sys/bus/usb/devices/*; do
          vendor="$(cat "$dev/idVendor" 2>/dev/null)"
          prod="$(cat "$dev/idProduct" 2>/dev/null)"

          if [[ "$vendor" != "" && "$prod" != "" ]]; then
              if [[ "$(lsusb -d "$vendor:$prod" | grep "Microsoft Corp. Xbox Controller")" != "" ]]; then
                  echo 0 > "$dev/authorized"
                  echo 1 > "$dev/authorized"
              fi
          fi
      done
    '';
  });

  hyprConf = pkgs.writeText "greetd-hypr-config" ''
    cursor {
        inactive_timeout = 1
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
    }

    decoration {
        blur {
            enabled = false
        }
    }

    animations {
        enabled = false
        first_launch_animation = false
    }

    bind = SUPER, Q, exec, kitty

    windowrule = fullscreen, ^(.*)$
    exec-once = waydroid show-full-ui
    exec-once = sleep 10; sudo ${connectControllers}
  '';

  user = "matt";
  command = "Hyprland --config ${hyprConf}";

  session = {inherit command user;};
in {
  # Make it so we don't need root to connect controllers
  security.sudo.extraRules = [
    {
      users = [user];
      groups = [user];
      commands = [
        {
          command = connectControllers;
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  # Stuff missing for complete declarative setup:
  #   - make the following declarative and also make the image declarative
  #   - Add this to /var/lib/waydroid/waydroid.cfg for controller support
  #       persist.waydroid.udev = true
  #       persist.waydroid.uevent = true
  virtualisation.waydroid.enable = true;

  users.users."greeter" = {
    home = "/var/lib/greeter";
  };

  programs.hyprland.enable = true;

  services = {
    greetd = {
      enable = true;

      settings = {
        default_session = session;
        initial_session = session;
      };
    };

    pipewire.enable = mkForce false;
  };

  environment.systemPackages = [pkgs.kitty];
}
