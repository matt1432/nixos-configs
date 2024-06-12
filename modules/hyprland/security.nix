{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.vars) mainUser;

  isLaptop = config.services.logind.lidSwitch == "lock";

  hmCfg = config.home-manager.users.${mainUser};
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
      user="$(id -u ${mainUser})"
      readarray -t SIGS <<< "$(ls "/run/user/$user/hypr/")"

      run() {
          export HYPRLAND_INSTANCE_SIGNATURE="$1"
          sudo -Eu ${mainUser} hyprctl dispatch exec "''${params[@]}"
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
      ags -b lockscreen -c /home/${mainUser}/.config/ags/lockscreen.js
    '';
  };
in {
  imports = [
    ../greetd
  ];

  services.gnome.gnome-keyring.enable = true;

  services.acpid = mkIf isLaptop {
    enable = true;

    lidEventCommands =
      # bash
      ''
        LID="/proc/acpi/button/lid/LID/state"
        state=$(${pkgs.gawk}/bin/awk '{print $2}' "$LID")

        case "$state" in
            *open*)
                ${runInDesktop}/bin/runInDesktop "ags -b lockscreen -r 'authFinger()'"
                ;;

            *close*)
                ${runInDesktop}/bin/runInDesktop ${lockPkg}/bin/lock
                ;;

            *)
                logger -t lid-handler "Failed to detect lid state ($state)"
                ;;
        esac
      '';
  };

  home-manager.users.${mainUser} = {
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
          "$mainMod, L, exec, ${lockPkg}/bin/lock"
        ];
      };
    };
  };
}
