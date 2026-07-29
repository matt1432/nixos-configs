self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind mkExecOnce;

  inherit (lib) getExe mkBefore mkIf optionalAttrs optionalString;

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
          cmd='hl.exec_cmd("'
          cmd+=''${params[*]}
          cmd+='")'
          sudo -Eu ${cfg.user} hyprctl dispatch "$cmd"
      }

      i=0

      while ! run "''${SIGS[$i]}"; do
          ((i+=1))
      done
    '';
  };

  keyringPassFile = config.sops.secrets.binto-keyring.path or "null";

  autoLoginKeyringFix = pkgs.writeShellApplication {
    name = "autoLoginKeyringFix";
    text = ''
      # Wait for keyring control socket to be available (up to 5 seconds)
      # shellcheck disable=SC2034
      for i in $(seq 1 10); do
          [ -S "$XDG_RUNTIME_DIR/keyring/control" ] && break
          sleep 0.5
      done

      # Check if keyring control socket exists
      if [ ! -S "$XDG_RUNTIME_DIR/keyring/control" ]; then
          echo "Keyring control socket not found after waiting, keyring may not be running" >&2
          echo "Keyring control socket not found after waiting, keyring may not be running" >> /tmp/gkd.log
          exit 1
      fi

      # Read the password from the sops-nix secret and unlock
      if [ -f "${keyringPassFile}" ]; then
          /run/wrappers/bin/gnome-keyring-daemon \
              --daemonize \
              --replace \
              --unlock \
              --components=secrets < "${keyringPassFile}" &> /tmp/gkd.log
      else
          echo "Keyring password file not found: ${keyringPassFile}" >&2
          echo "Keyring password file not found: ${keyringPassFile}" >> /tmp/gkd.log
          exit 1
      fi
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
        on = mkBefore (map mkExecOnce [
          (optionalString (keyringPassFile != "null")
            # lua
            ''
              hl.exec_cmd("${getExe autoLoginKeyringFix}")
            ''
            +
            # lua
            ''
              hl.exec_cmd("${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1")
            '')
        ]);

        window_rule = [
          {
            match.class = "^(org.kde.polkit-kde-authentication-agent-1)$";
            float = true;
            size = "741 288";
            move = "-50% -50%";
          }

          # For GParted auth
          {
            match.class = "^(ssh-askpass)$";
            size = "741 288";
            move = "cursor -370 -144";
          }
        ];

        bind = map mkBind [
          {
            keys = "SUPER + L";
            dispatcher =
              # lua
              ''
                hl.dsp.exec_cmd("${getExe lockPkg}")
              '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./security.nix;
}
