self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind mkExecOnce;
  inherit (self.inputs) nixcord;

  inherit (lib) attrValues getExe mkIf optionalAttrs optionals optionalString;
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
        ../home/obs.nix
        (import ../home/mpv.nix self)

        nixcord.homeModules.nixcord

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

        ({lib, ...}: {
          home.activation = {
            deleteDiscordSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
              run rm -f "$HOME/.config/discord/settings.json.bak"
            '';
          };
        })
      ];

      programs = {
        nixcord = {
          enable = true;

          discord = {
            package = nixcord.packages.${pkgs.stdenv.hostPlatform.system}.discord;

            vencord.enable = true;
            openASAR.enable = false;

            settings = {
              skipHostUpdate = true;
              dangerousEnableDevtoolsOnlyEnableIfYouKnowWhatYoureDoing = true;
              minWidth = 940;
              minHeight = 500;
              isMaximized = true;
              isMinimized = false;
              enableHardwareAcceleration = true;
            };
          };

          config = {
            notifyAboutUpdates = false;
            autoUpdate = false;
            autoUpdateNotification = false;

            themeLinks = [
              "https://markchan0225.github.io/RoundedDiscord/RoundedDiscord.theme.css"
              "https://raw.githubusercontent.com/dracula/BetterDiscord/master/Dracula_Official.theme.css"
            ];

            plugins = {
              alwaysTrust.enable = true;
              biggerStreamPreview.enable = true;
              clearUrls.enable = true;
              crashHandler.enable = true;
              disableCallIdle.enable = true;
              expressionCloner.enable = true;
              imageZoom.enable = true;
              memberCount.enable = true;
              messageLinkEmbeds.enable = true;

              messageLogger = {
                enable = true;
                ignoreBots = true;
                ignoreSelf = true;
              };

              mutualGroupDms.enable = true;
              onePingPerDm.enable = true;
              openInApp.enable = true;
              platformIndicators.enable = true;
              previewMessage.enable = true;
              readAllNotificationsButton.enable = true;
              reverseImageSearch.enable = true;
              spotifyCrack.enable = true;
              themeAttributes.enable = true;
              typingIndicator.enable = true;
              typingTweaks.enable = true;
              viewIcons.enable = true;
              viewRaw.enable = true;
              voiceChatDoubleClick.enable = true;
              volumeBooster.enable = true;
              whoReacted.enable = true;
            };
          };
        };

        sioyek = {
          enable = true;

          config = {
            startup_commands = ["toggle_custom_color"];
            ui_font = "JetBrainsMono Nerd Font Mono Regular";
            font_size = "24";
            source = toString pkgs.scopedPackages.dracula.sioyek;
          };
        };
      };

      home.packages = attrValues ({
          # KDE packages
          inherit
            (pkgs.kdePackages)
            kdenlive
            okular
            ;

          # School
          inherit (pkgs) libreoffice;
          inherit (pkgs.hunspellDicts) en_CA;
          inherit
            (pkgs)
            xournalpp
            virt-manager
            hunspell
            ;

          # Apps
          inherit
            (pkgs)
            gnome-calculator
            nextcloud-client
            protonmail-desktop # run with `XDG_SESSION_TYPE=x11 proton-mail` if it crashes  https://github.com/NixOS/nixpkgs/issues/365156
            spotifywm
            swayimg
            ;

          prismlauncher = pkgs.prismlauncher.override {
            jdk8 = pkgs.temurin-bin-8;
          };

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

          GParted = let
            inherit
              (pkgs)
              # build deps
              writeShellApplication
              makeWrapper
              symlinkJoin
              # deps
              gparted
              psmisc
              seahorse
              ;

            sudoWrapper = writeShellApplication {
              name = "GParted";
              runtimeInputs = [
                gparted
                psmisc
                "/run/wrappers"
              ];
              text = ''
                (
                sleep 1.5

                while killall -r -0 ssh-askpass > /dev/null 2>&1; do
                    sleep 0.1

                    if [[ $(hyprctl activewindow | grep ssh-askpass) == "" ]]; then
                        killall -r ssh-askpass
                    fi
                done
                ) &

                export SUDO_ASKPASS="${seahorse}/libexec/seahorse/ssh-askpass"

                exec sudo -k -EA gparted "$@"
              '';
            };
          in
            symlinkJoin {
              name = "gparted";
              paths = [gparted];
              buildInputs = [makeWrapper];
              postBuild = ''
                mkdir "$out/.wrapped"
                mv "$out/bin/gparted" "$out/.wrapped"
                cp "${getExe sudoWrapper}" "$out/bin/gparted"

                sed -i "s#Exec.*#Exec=$out/bin/gparted %f#" "$out/share/applications/gparted.desktop"
              '';
            };
        }
        // optionalAttrs cfg.easyeffects.enable {
          inherit (pkgs) easyeffects;
        });

      wayland.windowManager.hyprland = {
        settings = {
          on = map mkExecOnce [
            # lua
            ''
              hl.exec_cmd("${config.programs.kdeconnect.package}/libexec/kdeconnectd")
              hl.exec_cmd("kdeconnect-indicator")

              hl.exec_cmd("wl-paste --watch cliphist store")

              -- sleep to wait until system tray is started
              hl.exec_cmd("sleep 3; nextcloud --background")

              hl.exec_cmd("sleep 10; proton-mail", { workspace = "special:protonmail silent" })
              hl.exec_cmd("spotify", { workspace = "special:spot silent" })

              ${optionalString config.services.tailscale.enable "hl.exec_cmd(\"sleep 3; ${getExe restartTailscale}\")"}
              ${optionalString cfg.easyeffects.enable "hl.exec_cmd(\"sleep 3; easyeffects --hide-window\")"}
            ''
          ];

          window_rule =
            [
              {
                match.class = "^(libreoffice)$";
                float = false;
              }
              {
                match.class = "^(org.gnome.Calculator)$";
                float = true;
              }
              {
                match.class = "^(com.gabm.satty)$";
                float = true;
                size = "1000 700";
              }
              {
                match.class = "^(com.nextcloud.desktopclient.nextcloud)$";
                float = true;
                size = "400 581";
                move = "move 50 80";
              }
              {
                match.class = "^(Proton Mail)$";
                workspace = "special:protonmail silent";
              }
              {
                match.class = "^(spotify)$";
                workspace = "special:spot silent";
              }
            ]
            ++ optionals isNvidia [
              {
                match.class = "^(discord)$";
                workspace = "1 silent";
              }
              {
                match.class = "^(steam)$";
                workspace = "2 silent";
              }
              {
                match.class = "^(steam_app_.*)$";
                workspace = "2 silent";
                fullscreen = true;
              }
            ];

          workspace_rule = optionals isNvidia [
            {
              workspace = "1";
              monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";
              default = true;
            }
            {
              workspace = "2";
              monitor = cfg.mainMonitor;
              default = true;
            }
          ];

          bind = map mkBind [
            {
              keys = "SUPER + Q";
              dispatcher =
                # lua
                ''
                  hl.dsp.exec_cmd("foot")
                '';
            }

            {
              keys = "SUPER + SHIFT + C";
              dispatcher =
                # lua
                ''
                  hl.dsp.exec_cmd("wl-color-picker")
                '';
            }

            {
              keys = "SUPER + P";
              dispatcher =
                # lua
                ''
                  hl.dsp.workspace.toggle_special("protonmail")
                '';
            }
            {
              keys = "SUPER + S";
              dispatcher =
                # lua
                ''
                  hl.dsp.workspace.toggle_special("spot")
                '';
            }

            {
              keys = "mouse:277";
              dispatcher =
                # lua
                ''
                  hl.dsp.pass({ window = "class:^(discord)$" })
                '';
            }
          ];
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./packages.nix;
}
