{
  config,
  jellyfin-flake,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) makeLibraryPath optionalString;
  inherit (pkgs.writers) writeTOML;

  inherit (config.vars) mainUser;
  flakeDir = config.environment.variables.FLAKE;
in {
  imports = [../dolphin.nix];

  programs.kdeconnect.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      ../../home/foot.nix
      ../../home/mpv
      ../../home/obs.nix

      ({config, ...}: let
        symlink = config.lib.file.mkOutOfStoreSymlink;
        configDir = "${flakeDir}/modules/hyprland/config";
      in {
        xdg.configFile = {
          "dolphinrc".source = symlink "${configDir}/dolphinrc";
          "kdeglobals".source = symlink "${configDir}/kdeglobals";
          "kiorc".source = symlink "${configDir}/kiorc";
          "mimeapps.list".source = symlink "${configDir}/mimeapps.list";
          "neofetch".source = symlink "${configDir}/neofetch";

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
      })
    ];

    home.packages =
      (with pkgs; [
        # School
        xournalpp
        virt-manager
        libreoffice-fresh # TODO: declarative conf?
        hunspell
        hunspellDicts.en_CA

        # Apps
        thunderbird # TODO: use programs.thunderbird
        protonmail-bridge
        spotifywm
        photoqt
        nextcloud-client
        prismlauncher

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
        exec-once = [
          "${config.programs.kdeconnect.package}/libexec/kdeconnectd"
          "kdeconnect-indicator"

          "wl-paste --watch cliphist store"

          "sleep 3; nextcloud --background"
          "sleep 3; protonmail-bridge --noninteractive --log-level info"

          "[workspace special:thunder silent] thunderbird"
          "[workspace special:spot silent] spotify"
        ];

        windowrule = [
          "tile,^(libreoffice)$"
          "float,^(org.gnome.Calculator)$"
          "float,^(com.gabm.satty)$"
          "size 1000 700,^(com.gabm.satty)$"

          "float,^(com.nextcloud.desktopclient.nextcloud)$"
          "move cursor -15 -10,^(com.nextcloud.desktopclient.nextcloud)$"
          "size 400 581,^(com.nextcloud.desktopclient.nextcloud)$"

          "workspace special:thunder silent,^(thunderbird)$"
          "workspace special:spot silent,^(Spotify)$"
        ];

        bind = [
          "$mainMod, Q, exec, foot"

          "$mainMod SHIFT, C, exec, wl-color-picker"

          "$mainMod, T, togglespecialworkspace, thunder"
          "$mainMod, S, togglespecialworkspace, spot"
        ];
      };
    };
  };
}
