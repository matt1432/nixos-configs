self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind;
  inherit (self.inputs) jellyfin-flake nixcord;

  inherit (lib) attrValues getExe mkIf optionals;
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

        nixcord.homeManagerModules.nixcord

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

      programs = {
        nixcord = {
          enable = true;

          discord = {
            package =
              if isNvidia
              then
                pkgs.discord.overrideAttrs {
                  postFixup = ''
                    wrapProgramShell $out/bin/Discord \
                        --set XDG_SESSION_TYPE "x11" \
                        --unset NIXOS_OZONE_WL \
                        --unset WAYLAND_DISPLAY
                  '';
                }
              else pkgs.discord;

            # FIXME: https://github.com/KaylorBen/nixcord/issues/84
            vencord.unstable = false;
            openASAR.enable = false;

            settings = {
              skipHostUpdate = true;
              dangerousEnableDevtoolsOnlyEnableIfYouKnowWhatYoureDoing = true;
              minWidth = 940;
              minHeight = 500;
              isMaximized = true;
              isMinimized = false;
              enableHardwareAcceleration = !isNvidia;
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
              clearURLs.enable = true;
              crashHandler.enable = true;
              disableCallIdle.enable = true;
              emoteCloner.enable = true;
              imageZoom.enable = true;
              memberCount.enable = true;
              messageLinkEmbeds.enable = true;

              messageLogger = {
                enable = true;
                ignoreBots = true;
                ignoreSelf = true;
              };

              mutualGroupDMs.enable = true;
              onePingPerDM.enable = true;
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
            startup_commands = "toggle_custom_color";
            ui_font = "JetBrainsMono Nerd Font Mono Regular";
            font_size = "24";
            source = toString self.scopedPackages.${pkgs.system}.dracula.sioyek;
          };
        };
      };

      home.packages = attrValues {
        # School
        inherit (pkgs.hunspellDicts) en_CA;
        inherit
          (pkgs)
          xournalpp
          virt-manager
          libreoffice-fresh
          hunspell
          ;

        # Apps
        inherit
          (pkgs)
          protonmail-desktop # run with `XDG_SESSION_TYPE=x11 proton-mail` if it crashes  https://github.com/NixOS/nixpkgs/issues/365156
          spotifywm
          swayimg
          nextcloud-client
          prismlauncher
          vesktop # screen-sharing on desktop
          ;

        # force XWayland for stylus input
        obsidian = pkgs.obsidian.overrideAttrs {
          postFixup = ''
            wrapProgram $out/bin/obsidian \
                --set XDG_SESSION_TYPE "x11" \
                --unset NIXOS_OZONE_WL \
                --unset WAYLAND_DISPLAY
          '';
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

        jellyfinMediaPlayer =
          jellyfin-flake
          .packages
          .${pkgs.system}
          .jellyfin-media-player
          .override {isNvidiaWayland = isNvidia;};

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
              mkdir $out/.wrapped
              mv $out/bin/gparted $out/.wrapped
              cp ${getExe sudoWrapper} $out/bin/gparted

              sed -i "s#Exec.*#Exec=$out/bin/gparted %f#" $out/share/applications/gparted.desktop
            '';
          };
      };

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

          windowrulev2 =
            [
              "tile, class:^(libreoffice)$"
              "float, class:^(org.gnome.Calculator)$"
              "float, class:^(com.gabm.satty)$"
              "size 1000 700, class:^(com.gabm.satty)$"

              "float, class:^(com.nextcloud.desktopclient.nextcloud)$"
              "move cursor -15 -10, class:^(com.nextcloud.desktopclient.nextcloud)$"
              "size 400 581, class:^(com.nextcloud.desktopclient.nextcloud)$"

              "workspace special:protonmail silent, class:^(Proton Mail)$"
              "workspace special:spot silent, class:^(Spotify)$"
            ]
            ++ optionals isNvidia [
              "workspace 1 silent, class:^(discord)$"
              "workspace 2 silent, class:^(steam)$"
              "workspace 2 silent, initialTitle:^(.*Marvel Rivals.*)$"
            ];

          workspace = optionals isNvidia [
            "1, monitor:desc:Acer Technologies Acer K212HQL T3EAA0014201, default:true"
            "2, monitor:${cfg.mainMonitor}, default:true"
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

            {
              key = "mouse:277";
              dispatcher = "pass";
              command = "class:^(discord)$";
            }
          ];
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./packages.nix;
}
