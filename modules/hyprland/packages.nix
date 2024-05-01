{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) makeLibraryPath optionalString;
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
        };
      })
    ];

    home.packages = with pkgs; [
      # School
      xournalpp
      virt-manager
      libreoffice-fresh # TODO: declarative conf?
      hunspell
      hunspellDicts.en_CA
      config.customPkgs.rars-flatlaf

      # Apps
      thunderbird # TODO: use programs.thunderbird
      protonmail-bridge
      spotifywm
      photoqt
      nextcloud-client
      jellyfin-media-player
      prismlauncher-qt5

      # tools
      wl-color-picker
      wl-clipboard
      cliphist
      grim
      slurp
      satty

      # TODO: make an ags widget to select windows, screens or a selection
      (writeShellApplication {
        name = "screenshot";
        runtimeInputs = [
          config.programs.hyprland.package
          satty
          grim
          jq
        ];
        text = ''
          screen=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')
          exec grim -o "$screen" - | satty -f - --output-filename "/home/matt/Pictures/Screenshots/screenshot-$(date --iso-8601=seconds).png"
        '';
      })

      /*
      Discord themes for Vencord
      https://markchan0225.github.io/RoundedDiscord/RoundedDiscord.theme.css
      https://raw.githubusercontent.com/dracula/BetterDiscord/master/Dracula_Official.theme.css
      */
      (symlinkJoin {
        name = "discord";
        paths = [
          (discord.override {
            withOpenASAR = true;
            withVencord = true;
          })
        ];
        buildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/Discord ${optionalString config.nvidia.enable
            ''--prefix LD_LIBRARY_PATH : "${makeLibraryPath [
                addOpenGLRunpath.driverLink
                libglvnd
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

          # Clipboard History
          "$mainMod, V, exec, ags -t win-clipboard"

          "        , Print, exec, screenshot"
          "$mainMod, Print, exec, grim -g \"$(slurp)\" - | satty -f - --output-filename \"screenshot-$(date --iso-8601=seconds)\""
          "$mainMod SHIFT, C, exec, wl-color-picker"

          "$mainMod, T, togglespecialworkspace, thunder"
          "$mainMod, S, togglespecialworkspace, spot"
        ];
      };
    };
  };
}
