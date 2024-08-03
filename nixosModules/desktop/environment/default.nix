self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) hyprgrass hyprland hyprland-plugins;
in {
  imports = [
    (import ../../ags self)

    ./modules/dconf.nix
    ./modules/printer.nix
    ./modules/security.nix
    (import ./modules/audio.nix self)
    (import ./modules/packages.nix self)
    (import ./modules/ratbag-mice.nix self)
  ];

  config = let
    inherit (lib) concatStringsSep optionals;

    cfg = config.roles.desktop;

    hyprCfg =
      config
      .home-manager
      .users
      .${cfg.user}
      .wayland
      .windowManager
      .hyprland;
  in {
    services = {
      dbus.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
      xserver.wacom.enable = cfg.isTouchscreen;
    };

    programs.hyprland = {
      enable = true;
      package = hyprCfg.finalPackage;
      portalPackage =
        hyprland
        .packages
        .${pkgs.system}
        .xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];

      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];

        "org.freedesktop.impl.portal.FileChooser" = [
          "kde"
        ];
      };
    };

    home-manager.users.${cfg.user} = {
      imports = [
        ./home/dev.nix

        # Plugins
        (import ./home/hyprexpo.nix hyprland-plugins)
        (import ./home/hyprgrass.nix hyprgrass)

        ./home/inputs.nix
        (import ./home/style.nix self)
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package =
          hyprland
          .packages
          .${pkgs.system}
          .default;

        systemd.variables = ["-all"];

        settings = {
          envd = let
            mkGSchemas = pkg: "${pkg}/share/gsettings-schemas/${pkg.name}";
          in
            [
              "GTK_USE_PORTAL, 1"
              "NIXOS_OZONE_WL, 1"
              "ELECTRON_OZONE_PLATFORM_HINT, auto"

              "XDG_DATA_DIRS, ${concatStringsSep ":" [
                (mkGSchemas pkgs.gsettings-desktop-schemas)
                (mkGSchemas pkgs.gtk3)
                "$XDG_DATA_DIRS"
              ]}"
            ]
            ++ (optionals config.nvidia.enable [
              "LIBVA_DRIVER_NAME, nvidia"
              "NVD_BACKEND, direct"
              "XDG_SESSION_TYPE, wayland"
              "GBM_BACKEND, nvidia-drm"
              "__GLX_VENDOR_LIBRARY_NAME, nvidia"
            ]);

          xwayland.force_zero_scaling = true;
          monitor = [
            (concatStringsSep "," [
              "desc:Acer Technologies Acer K212HQL T3EAA0014201"
              "1920x1080@60"
              "840x450, 1, transform, 3"
            ])
            (concatStringsSep "," [
              "desc:BOE 0x0964"
              "1920x1200@60"
              "0x2920, 1"
            ])
            (concatStringsSep "," [
              "desc:Samsung Electric Company C27JG5x HTOM100586"
              "2560x1440@120"
              "1920x120, 1"
            ])
            (concatStringsSep "," [
              "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D"
              "2560x1440@120"
              "1920x1560, 1"
            ])
          ];

          "$mainMod" = "SUPER";

          bind = [
            # Defaults
            "$mainMod, F,    fullscreen"
            "$mainMod, C,    killactive"
            "$mainMod SHIFT, SPACE,     togglefloating"
            "$mainMod, J,    layoutmsg, togglesplit"

            ## Move focus with arrow keys
            "$mainMod, left,  movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up,    movefocus, u"
            "$mainMod, down,  movefocus, d"

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

            ",XF86AudioMute,    exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
            ",XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
          ];

          binde = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ & ags -r 'popup_osd(\"speaker\")' &"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- & ags -r 'popup_osd(\"speaker\")' &"
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

          dwindle = {
            smart_split = true;
            special_scale_factor = 0.8;
          };
        };
      };

      # libs
      home.packages = with pkgs; [
        # tools
        bluez-tools
        brightnessctl
        pulseaudio
        alsa-utils

        qt5.qtwayland
        qt6.qtwayland
        libayatana-appindicator
        xdg-utils
        evtest
        glib
        xorg.xrandr
        libinput
        xclip
        libnotify
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
