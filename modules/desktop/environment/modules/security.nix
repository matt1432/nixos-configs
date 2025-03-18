self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind;

  inherit (lib) getExe map mkIf;

  cfg = config.roles.desktop;

  hmCfg = config.home-manager.users.${cfg.user};
  hyprPkg = hmCfg.wayland.windowManager.hyprland.finalPackage;

  # See modules/ags/packages.nix
  lockPkg = hmCfg.programs.ags.lockPkg;

  runInDesktop = pkgs.writeShellApplication {
    name = "runInDesktop";
    runtimeInputs = [
      pkgs.sudo
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

      while ! run "''${SIGS[$i]}"; do
          ((i+=1))
      done
    '';
  };
in {
  config = mkIf cfg.enable {
    services.acpid = mkIf cfg.isLaptop {
      enable = true;

      lidEventCommands =
        # bash
        ''
          LID="/proc/acpi/button/lid/LID/state"
          state=$(${pkgs.gawk}/bin/awk '{print $2}' "$LID")

          case "$state" in
              *open*)
                  ${getExe runInDesktop} "${getExe lockPkg} request 'authFinger()'"
                  ;;

              *close*)
                  ${getExe runInDesktop} "${getExe lockPkg}"
                  ;;

              *)
                  logger -t lid-handler "Failed to detect lid state ($state)"
                  ;;
          esac
        '';
    };

    home-manager.users.${cfg.user} = {
      home.packages = [
        pkgs.seahorse
        lockPkg
      ];

      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "gnome-keyring-daemon --start --components=secrets"
          "${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        ];

        windowrule = [
          "float       , class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "size 741 288, class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "center      , class:^(org.kde.polkit-kde-authentication-agent-1)$"

          # For GParted auth
          "size 741 288         , class:^(ssh-askpass)$"
          "move cursor -370 -144, class:^(ssh-askpass)$"
        ];

        bind = map mkBind [
          {
            modifier = "$mainMod";
            key = "L";
            command = getExe lockPkg;
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./security.nix;
}
