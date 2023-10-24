{ pkgs, config, hyprland, hyprgrass, ags, osConfig, ... }: let
  configDir = config.services.hostvars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;

  gset = pkgs.gsettings-desktop-schemas;
  polkit = pkgs.plasma5Packages.polkit-kde-agent;
in {
  imports = [
    ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = symlink "${configDir}/ags";
    package = (ags.packages.x86_64-linux.default.overrideAttrs
      (_: prev: {
        buildInputs = with pkgs; prev.buildInputs ++ [
          libgudev
        ];
      })
    );
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.x86_64-linux.default;

    plugins = [
      "${hyprgrass.packages.x86_64-linux.default}/lib/libhyprgrass.so"
    ];

    settings = {
      env = [
        "XDG_DATA_DIRS, ${builtins.concatStringsSep ":" [
          "${gset}/share/gsettings-schemas/${gset.name}"
          "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
          "$XDG_DATA_DIRS"
        ]}"

        "AGS_PATH, ${configDir}/ags/bin"
        "HYPR_PATH, ${configDir}/hypr/scripts"
        "LOCK_PATH, ${configDir}/gtklock/scripts"
      ];

      exec-once = [
        "${polkit}/libexec/polkit-kde-authentication-agent-1"
        "${osConfig.programs.kdeconnect.package}/libexec/kdeconnectd"
      ];

      source = [ "~/.config/hypr/main.conf" ];
    };
  };

  xdg.configFile = {
    "hypr/main.conf".source    = symlink "${configDir}/hypr/main.conf";

    "hypr/hyprpaper.conf".text = ''
      preload = ${pkgs.dracula-theme}/wallpapers/waves.png
      wallpaper = eDP-1, ${pkgs.dracula-theme}/wallpapers/waves.png
    '';
  };

  home.packages = with pkgs; [
    # ags
    sassc
    coloryou
    libnotify
    playerctl
    bluez-tools
    brightnessctl
    pulseaudio
    libinput

    ## gui
    pavucontrol # TODO: replace with ags widget
    networkmanagerapplet # TODO: replace with ags widget
    blueberry # TODO: replace with ags widget


    # Hyprland
    hyprpaper
    swayidle
    lisgd
    swayosd
    squeekboard
    xclip
    wl-clipboard
    cliphist

    ## gui
    gtklock
    wl-color-picker # TODO: add bind for this in hyprland
    grim
    slurp
    swappy

    ## libs
    libayatana-appindicator
    xdg-utils
    evtest
    glib
  ];
}
