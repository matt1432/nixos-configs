{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkIf;

  cfg = config.roles.desktop;

  hmCfg = config.home-manager.users.${cfg.user};
  agsPkg = hmCfg.programs.ags.finalPackage;
  hyprPkg = hmCfg.wayland.windowManager.hyprland.finalPackage;

  runInDesktop = pkgs.writeShellApplication {
    name = "runInDesktop";
    runtimeInputs = [
      pkgs.sudo
      agsPkg
      hyprPkg
    ];

    text = ''
      params=( "$@" )
      user="$(id -u ${cfg.user})"
      readarray -t SIGS <<< "$(ls "/run/user/$user/hypr/")"

      run() {
          export HYPRLAND_INSTANCE_SIGNATURE="$1"
          sudo -Eu ${cfg.user} hyprctl dispatch exec "''${params[@]}"
      }

      i=0

      # FIXME: not sure if sudo passes the exit status to this
      while ! run "''${SIGS[$i]}"; do
          ((i+=1))
      done
    '';
  };

  lockPkg = pkgs.writeShellApplication {
    name = "lock";
    runtimeInputs = [
      agsPkg
    ];

    text = ''
      ags -r 'Tablet.setLaptopMode()'
      ags -b lockscreen -c /home/${cfg.user}/.config/ags/lockscreen.js
    '';
  };
in {
  services.acpid = mkIf cfg.isLaptop {
    enable = true;

    lidEventCommands =
      # bash
      ''
        LID="/proc/acpi/button/lid/LID/state"
        state=$(${pkgs.gawk}/bin/awk '{print $2}' "$LID")

        case "$state" in
            *open*)
                ${getExe runInDesktop} "ags -b lockscreen -r 'authFinger()'"
                ;;

            *close*)
                ${getExe runInDesktop} ${getExe lockPkg}
                ;;

            *)
                logger -t lid-handler "Failed to detect lid state ($state)"
                ;;
        esac
      '';
  };

  home-manager.users.${cfg.user} = {
    home.packages = [
      pkgs.gnome.seahorse
      lockPkg
    ];

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "gnome-keyring-daemon --start --components=secrets"
          "${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        ];

        windowrule = [
          "float,^(org.kde.polkit-kde-authentication-agent-1)$"
          "size 741 288,^(org.kde.polkit-kde-authentication-agent-1)$"
          "center,^(org.kde.polkit-kde-authentication-agent-1)$"

          # For GParted auth
          "size 741 288,^(org.kde.ksshaskpass)$"
          "move cursor -370 -144,^(org.kde.ksshaskpass)$"
        ];

        bind = [
          "$mainMod, L, exec, ${getExe lockPkg}"
        ];
      };
    };
  };
}
