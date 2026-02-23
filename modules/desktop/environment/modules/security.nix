self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind;

  inherit (lib) getExe mkBefore mkIf optionalAttrs;

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

    # unlock GPG keyring on login
    services.gnome.gnome-keyring.enable = true;

    security.pam.services =
      {
        login.enableGnomeKeyring = true;
      }
      // (optionalAttrs cfg.displayManager.enable {
        greetd.enableGnomeKeyring = true;
      });

    environment.sessionVariables = {
      # Tell Electron apps where to find the keyring
      GNOME_KEYRING_CONTROL = "\${XDG_RUNTIME_DIR}/keyring";
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/keyring/ssh";
    };

    home-manager.users.${cfg.user} = {
      home.packages = [
        pkgs.seahorse
        pkgs.libsecret
        pkgs.libgnome-keyring # Required for Electron apps (moved to top-level)

        lockPkg
      ];

      wayland.windowManager.hyprland.settings = {
        exec-once = mkBefore [
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        ];

        windowrule = [
          "float on      , match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
          "size 741 288  , match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
          "move -50% -50%, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"

          # For GParted auth
          "size 741 288         , match:class ^(ssh-askpass)$"
          "move cursor -370 -144, match:class ^(ssh-askpass)$"
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
