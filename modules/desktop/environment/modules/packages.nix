self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind;
  inherit (self.inputs) jellyfin-flake;

  inherit (lib) getExe mkIf optionals;
  inherit (pkgs.writers) writeTOML;

  cfg = config.roles.desktop;

  flakeDir = config.environment.variables.FLAKE;
  isNvidia = config.nvidia.enable;

  restartTailscale = pkgs.writeShellScriptBin "restartTailscale" ''
    sudo ${pkgs.systemd}/bin/systemctl restart tailscaled.service
  '';
in {
  imports = [./dolphin.nix];

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;

    security.sudo.extraRules = [
      {
        users = [cfg.user];
        groups = [100];
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl restart tailscaled.service";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];

    home-manager.users.${cfg.user} = {
      imports = [
        ../home/foot.nix
        (import ../home/mpv.nix self)
        (import ../home/obs.nix self)

        ({config, ...}: let
          inherit (config.lib.file) mkOutOfStoreSymlink;
          configDir = "${flakeDir}/modules/desktop/environment/config";
        in {
          xdg.configFile = {
            "dolphinrc".source = mkOutOfStoreSymlink "${configDir}/dolphinrc";
            "kdeglobals".source = mkOutOfStoreSymlink "${configDir}/kdeglobals";
            "kiorc".source = mkOutOfStoreSymlink "${configDir}/kiorc";
            "mimeapps.list".source = mkOutOfStoreSymlink "${configDir}/mimeapps.list";

            "satty/config.toml".source = writeTOML "satty.toml" {
              general = {
                early-exit = true;
                copy-command = "wl-copy";
                initial-tool = "crop";
                output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/screen-%d-%m-%Y_%H:%M:%S.png";
              };
              font.family = "Ubuntu Mono";
            };
          };
        })
      ];

      programs.sioyek = {
        enable = true;

        config = {
          startup_commands = "toggle_custom_color";
          ui_font = "JetBrainsMono Nerd Font Mono Regular";
          font_size = "24";
          source = toString self.scopedPackages.${pkgs.system}.dracula.sioyek;
        };
      };

      home.packages =
        (builtins.attrValues {
          # School
          inherit (pkgs.hunspellDicts) en_CA;
          inherit
            (pkgs)
            xournalpp
            virt-manager
            libreoffice-fresh # TODO: declarative conf?
            hunspell
            ;

          # Apps
          inherit
            (pkgs)
            protonmail-desktop
            spotifywm
            swayimg
            nextcloud-client
            prismlauncher
            ;

          # tools
          inherit
            (pkgs)
            grim-hyprland
            wl-color-picker
            wl-clipboard
            cliphist
            slurp
            satty
            ;
        })
        ++ [
          (jellyfin-flake
            .packages
            .${pkgs.system}
            .jellyfin-media-player
            .override {isNvidiaWayland = isNvidia;})

          /*
          Discord themes for Vencord
          https://markchan0225.github.io/RoundedDiscord/RoundedDiscord.theme.css
          https://raw.githubusercontent.com/dracula/BetterDiscord/master/Dracula_Official.theme.css
          */
          (pkgs.discord.override {withVencord = true;})
          pkgs.vesktop

          # GParted
          (let
            inherit (pkgs) writeShellScriptBin libsForQt5 gparted makeWrapper symlinkJoin;

            newWrapper = writeShellScriptBin "Gparted" ''
              (
                  sleep 1.5
                  while killall -r -0 ksshaskpass > /dev/null 2>&1
                  do
                      sleep 0.1
                      if [[ $(hyprctl activewindow | grep Ksshaskpass) == "" ]]; then
                          killall -r ksshaskpass
                      fi
                  done
              ) &
              exec env SUDO_ASKPASS="${libsForQt5.ksshaskpass}/bin/ksshaskpass" sudo -k -EA "${getExe gparted}" "$@"
            '';
          in
            symlinkJoin {
              name = "gparted";
              paths = [gparted];
              buildInputs = [makeWrapper];
              postBuild = let
              in ''
                mkdir $out/.wrapped
                mv $out/bin/gparted $out/.wrapped
                cp ${getExe newWrapper} $out/bin/gparted

                sed -i "s#Exec.*#Exec=$out/bin/gparted %f#" $out/share/applications/gparted.desktop
              '';
            })
        ];

      wayland.windowManager.hyprland = {
        settings = {
          exec-once =
            [
              "${config.programs.kdeconnect.package}/libexec/kdeconnectd"
              "kdeconnect-indicator"

              "wl-paste --watch cliphist store"

              "sleep 3; nextcloud --background"

              "[workspace special:protonmail silent] sleep 10; proton-mail"
              "[workspace special:spot silent] spotify"
            ]
            ++ optionals config.services.tailscale.enable [
              "sleep 3; ${getExe restartTailscale}"
            ];

          windowrule = [
            "tile,^(libreoffice)$"
            "float,^(org.gnome.Calculator)$"
            "float,^(com.gabm.satty)$"
            "size 1000 700,^(com.gabm.satty)$"

            "float,^(com.nextcloud.desktopclient.nextcloud)$"
            "move cursor -15 -10,^(com.nextcloud.desktopclient.nextcloud)$"
            "size 400 581,^(com.nextcloud.desktopclient.nextcloud)$"

            "workspace special:protonmail silent,^(Proton Mail)$"
            "workspace special:spot silent,^(Spotify)$"
          ];

          bind = map mkBind [
            {
              modifier = "$mainMod";
              key = "Q";
              command = "foot";
            }

            {
              modifier = "$mainMod SHIFT";
              key = "C";
              command = "wl-color-picker";
            }

            {
              modifier = "$mainMod";
              key = "P";
              dispatcher = "togglespecialworkspace";
              command = "protonmail";
            }
            {
              modifier = "$mainMod";
              key = "S";
              dispatcher = "togglespecialworkspace";
              command = "spot";
            }
          ];
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./packages.nix;
}
