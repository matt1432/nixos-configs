{
  config,
  jellyfin-flake,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe makeLibraryPath mkIf optionals optionalString;
  inherit (pkgs.writers) writeTOML;

  flakeDir = config.environment.variables.FLAKE;
  cfg = config.roles.desktop;
  nvidiaEnable = config.nvidia.enable;

  restartTailscale = pkgs.writeShellScriptBin "restartTailscale" ''
    sudo ${pkgs.systemd}/bin/systemctl restart tailscaled.service
  '';
in {
  imports = [./dolphin.nix];

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
      ./home/foot.nix
      ./home/mpv.nix
      ./home/obs.nix

      ({config, ...}: let
        symlink = config.lib.file.mkOutOfStoreSymlink;
        configDir = "${flakeDir}/modules/desktop/desktop-environment/config";
      in {
        xdg = {
          configFile = {
            "dolphinrc".source = symlink "${configDir}/dolphinrc";
            "kdeglobals".source = symlink "${configDir}/kdeglobals";
            "kiorc".source = symlink "${configDir}/kiorc";
            "mimeapps.list".source = symlink "${configDir}/mimeapps.list";

            "satty/config.toml".source = writeTOML "satty.toml" {
              general = {
                early-exit = true;
                copy-command = "wl-copy";
                initial-tool = "crop";
                output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/screen-%d-%m-%Y_%H:%M:%S.png";
              };

              font = {
                family = "Ubuntu Mono";
              };
            };
          };

          desktopEntries =
            (mkIf nvidiaEnable {
              "com.github.iwalton3.jellyfin-media-player" = {
                name = "Jellyfin Media Player";
                comment = "Desktop client for Jellyfin";
                exec = "jellyfinmediaplayer --platform xcb";
                icon = "com.github.iwalton3.jellyfin-media-player";
                terminal = false;
                type = "Application";
                categories = ["AudioVideo" "Video" "Player" "TV"];
                settings = {
                  Version = "1.0";
                  StartupWMClass = "jellyfin-media-player";
                };
                actions = {
                  "DesktopF" = {
                    name = "Desktop [Fullscreen]";
                    exec = "jellyfinmediaplayer --fullscreen --desktop --platform xcb";
                  };
                  "DesktopW" = {
                    name = "Desktop [Windowed]";
                    exec = "jellyfinmediaplayer --windowed --desktop --platform xcb";
                  };
                  "TVF" = {
                    name = "TV [Fullscreen]";
                    exec = "jellyfinmediaplayer --fullscreen --tv --platform xcb";
                  };
                  "TVW" = {
                    name = "TV [Windowed]";
                    exec = "jellyfinmediaplayer --windowed --tv --platform xcb";
                  };
                };
              };
            })
            // {
              gparted = {
                name = "GParted";
                genericName = "Partition Editor";
                comment = "Create, reorganize, and delete partitions";
                exec = "Gparted";
                icon = "gparted";
                terminal = false;
                type = "Application";
                categories = ["GNOME" "System" "Filesystem"];
                startupNotify = true;
                settings = {
                  Keywords = "Partition";
                  X-GNOME-FullName = "GParted Partition Editor";
                };
              };
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
        source = toString self.legacyPackages.${pkgs.system}.dracula.sioyek;
      };
    };

    home.packages =
      (with pkgs; [
        # School
        xournalpp
        virt-manager
        libreoffice-fresh # TODO: declarative conf?
        hunspell
        hunspellDicts.en_CA

        # Apps
        protonmail-desktop
        spotifywm
        photoqt
        nextcloud-client
        prismlauncher

        (writeShellScriptBin "Gparted" ''
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
          exec env SUDO_ASKPASS=${plasma5Packages.ksshaskpass}/bin/${plasma5Packages.ksshaskpass.pname} sudo -k -EA "${gparted}/bin/${gparted.pname}" "$@"
        '')

        # tools
        wl-color-picker
        wl-clipboard
        cliphist
        grim-hyprland
        slurp
        satty
      ])
      ++ [
        jellyfin-flake.packages.${pkgs.system}.jellyfin-media-player

        /*
        Discord themes for Vencord
        https://markchan0225.github.io/RoundedDiscord/RoundedDiscord.theme.css
        https://raw.githubusercontent.com/dracula/BetterDiscord/master/Dracula_Official.theme.css
        */
        (pkgs.symlinkJoin {
          name = "discord";
          paths = [
            (pkgs.discord.override {
              withOpenASAR = true;
              withVencord = true;
            })
          ];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/Discord ${optionalString config.nvidia.enable
              ''--prefix LD_LIBRARY_PATH : "${makeLibraryPath [
                  pkgs.addOpenGLRunpath.driverLink
                  pkgs.libglvnd
                ]}"''} \
            --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland"
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

            "[workspace special:protonmail silent] proton-mail"
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

        bind = [
          "$mainMod, Q, exec, foot"

          "$mainMod SHIFT, C, exec, wl-color-picker"

          "$mainMod, P, togglespecialworkspace, protonmail"
          "$mainMod, S, togglespecialworkspace, spot"
        ];
      };
    };
  };
}
