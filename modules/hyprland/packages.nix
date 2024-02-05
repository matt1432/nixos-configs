{
  config,
  pkgs,
  ...
}: let
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
      spotifywm
      photoqt
      nextcloud-client
      jellyfin-media-player
      prismlauncher-qt5

      /*
      Discord themes for Vencord
      https://markchan0225.github.io/RoundedDiscord/RoundedDiscord.theme.css
      https://raw.githubusercontent.com/dracula/BetterDiscord/master/Dracula_Official.theme.css
      */
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })

      # tools
      wl-color-picker
      wl-clipboard
      cliphist
      grim
      slurp
      swappy
    ];

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "${config.programs.kdeconnect.package}/libexec/kdeconnectd"
          "kdeconnect-indicator"

          "wl-paste --watch cliphist store"

          "sleep 3; nextcloud --background"

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
