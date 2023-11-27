{
  config,
  osConfig,
  hyprland,
  hyprgrass,
  pkgs,
  lib,
  ...
}: let
  configDir = config.services.device-vars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
  optionals = lib.lists.optionals;
  isNvidia = osConfig.hardware.nvidia.modesetting.enable;

  gset = pkgs.gsettings-desktop-schemas;
  polkit = pkgs.plasma5Packages.polkit-kde-agent;
in {
  imports = [
    ./theme.nix
    ../alacritty.nix
    ../wofi
  ];

  xdg.configFile = lib.mkIf (configDir != null) {
    "hypr/main.conf".source = symlink "${configDir}/hypr/main.conf";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.x86_64-linux.default;

    settings = {
      env =
        [
          "XCURSOR_SIZE, 24"
          "XDG_DATA_DIRS, ${builtins.concatStringsSep ":" [
            "${gset}/share/gsettings-schemas/${gset.name}"
            "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
            "$XDG_DATA_DIRS"
          ]}"
        ]
        ++ (optionals isNvidia [
          "LIBVA_DRIVER_NAME, nvidia"
          "XDG_SESSION_TYPE, wayland"
          "GBM_BACKEND, nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME, nvidia"
          "WLR_NO_HARDWARE_CURSORS, 1"
        ]);

      xwayland.force_zero_scaling = true;
      monitor = [
        (builtins.concatStringsSep "," [
          "desc:Acer Technologies Acer K212HQL T3EAA0014201"
          "1920x1080@60"
          "840x1000, 1, transform, 3"
        ])
        (builtins.concatStringsSep "," [
          "desc:BOE 0x0964"
          "1920x1200@60"
          "0x2920, 1"
        ])
        (builtins.concatStringsSep "," [
          "desc:Samsung Electric Company C27JG5x HTOM100586"
          "2560x1440@60"
          "1920x120, 1"
        ])

        # Desc of main monitor has comma, so force its default
        # on everything and specify everything else
        ",2560x1440@165, 1920x1560, 1"
      ];

      input = {
        kb_layout = osConfig.services.xserver.layout;
        kb_variant = osConfig.services.xserver.xkbVariant;
        follow_mouse = true;

        touchpad.natural_scroll = true;
      };

      exec-once =
        [
          "hyprctl setcursor Dracula-cursors 24"
          "${polkit}/libexec/polkit-kde-authentication-agent-1"
          "swww init --no-cache && swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png"
          "wl-paste --watch cliphist store"
        ]
        ++ (optionals (osConfig.programs.kdeconnect.enable) [
          "${osConfig.programs.kdeconnect.package}/libexec/kdeconnectd"
          "kdeconnect-indicator"
        ])
        ++ (optionals (osConfig.services.gnome.gnome-keyring.enable) [
          "gnome-keyring-daemon --start --components=secrets"
        ])
        # FIXME: https://github.com/horriblename/hyprgrass/issues/65
        ++ (optionals (osConfig.hardware.sensor.iio.enable) [
          "sleep 3; hyprctl plugin load ${hyprgrass.packages.${pkgs.system}.default}/lib/libhyprgrass.so"
        ]);

      windowrule = [
        "noborder,^(wofi)$"

        # Polkit
        "float,^(org.kde.polkit-kde-authentication-agent-1)$"
        "size 741 288,^(org.kde.polkit-kde-authentication-agent-1)$"
        "center,^(org.kde.polkit-kde-authentication-agent-1)$"
      ];

      "$mainMod" = "SUPER";

      bind = [
        # Defaults
        "$mainMod, Q, exec, alacritty"
        "$mainMod, F, fullscreen"
        "$mainMod, C, killactive,"
        "$mainMod SHIFT, SPACE, togglefloating,"
        "$mainMod, J, togglesplit,"

        ## Move focus with arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        ## Move to specific workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Clipboard History
        "$mainMod, V, exec, killall -r wofi || cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        ",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mainMod SHIFT, C, exec, wl-color-picker"

        ",XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ",XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
      ];

      binde = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      # Mouse Binds
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
      };

      source =
        []
        ++ optionals (configDir != null) [
          "~/.config/hypr/main.conf"
        ];
    };
  };

  home.packages = with pkgs; [
    # tools
    wl-color-picker
    grim
    slurp
    swappy
    swayidle
    bluez-tools
    brightnessctl
    pulseaudio
    gnome.seahorse

    gtklock
    swww

    ## libs
    qt5.qtwayland
    qt6.qtwayland
    libayatana-appindicator
    xdg-utils
    evtest
    glib
    xorg.xrandr
    libinput
    xclip
    wl-clipboard
    cliphist
    libnotify
  ];
}
