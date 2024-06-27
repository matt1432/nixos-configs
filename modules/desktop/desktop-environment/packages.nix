{
  config,
  jellyfin-flake,
  lib,
  pkgs,
  self,
  Vencord-src,
  ...
}: let
  inherit (lib) makeLibraryPath optionalString;
  inherit (pkgs.writers) writeTOML;

  flakeDir = config.environment.variables.FLAKE;
  cfg = config.roles.desktop;
in {
  imports = [./dolphin.nix];

  programs.kdeconnect.enable = true;

  home-manager.users.${cfg.user} = {
    imports = [
      ./home/foot.nix
      ./home/mpv.nix
      ./home/obs.nix

      ({config, ...}: let
        symlink = config.lib.file.mkOutOfStoreSymlink;
        configDir = "${flakeDir}/modules/desktop/desktop-environment/config";
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

          "[workspace special:protonmail silent] proton-mail"
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
