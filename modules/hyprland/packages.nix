{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) makeLibraryPath optionalString;
  inherit (config.vars) mainUser;
in {
  imports = [../dolphin.nix];

  programs.kdeconnect.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      ../../home/foot.nix
      ../../home/mpv
      ../../home/obs.nix
      ../../home/wofi

      ({config, ...}: let
        symlink = config.lib.file.mkOutOfStoreSymlink;
        configDir = "/home/${mainUser}/.nix/modules/hyprland/config";
      in {
        xdg.configFile = {
          "dolphinrc".source = symlink "${configDir}/dolphinrc";
          "kdeglobals".source = symlink "${configDir}/kdeglobals";
          "kiorc".source = symlink "${configDir}/kiorc";
          "mimeapps.list".source = symlink "${configDir}/mimeapps.list";
          "neofetch".source = symlink "${configDir}/neofetch";
          "swappy".source = symlink "${configDir}/swappy";
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
      swappy

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
          "noborder,^(wofi)$"
          "tile,^(libreoffice)$"
          "float,^(org.gnome.Calculator)$"

          "float,^(com.nextcloud.desktopclient.nextcloud)$"
          "move cursor -15 -10,^(com.nextcloud.desktopclient.nextcloud)$"
          "size 400 581,^(com.nextcloud.desktopclient.nextcloud)$"

          "workspace special:thunder silent,^(thunderbird)$"
          "workspace special:spot silent,^(Spotify)$"
        ];

        bind = [
          "$mainMod, Q, exec, foot"

          # Clipboard History
          "$mainMod, V, exec, killall -r wofi || cliphist list | wofi --dmenu | cliphist decode | wl-copy"

          ",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
          "$mainMod SHIFT, C, exec, wl-color-picker"

          "$mainMod, T, togglespecialworkspace, thunder"
          "$mainMod, S, togglespecialworkspace, spot"
        ];
      };
    };
  };
}
