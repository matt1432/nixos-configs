{ pkgs, config, hyprland, osConfig, ... }: let
  configDir = config.services.device-vars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;

  polkit = pkgs.plasma5Packages.polkit-kde-agent;
in {
  # FIXME: steam flicker issues
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    package = hyprland.packages.x86_64-linux.default;

    settings = {
      # Nvidia stuff
      env = [
        "LIBVA_DRIVER_NAME, nvidia"
        "XDG_SESSION_TYPE, wayland"
        "GBM_BACKEND, nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME, nvidia"
        "WLR_NO_HARDWARE_CURSORS, 1"
      ];

      exec-once = [
        "${polkit}/libexec/polkit-kde-authentication-agent-1"
        "${osConfig.programs.kdeconnect.package}/libexec/kdeconnectd"
        "swww init --no-cache && swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png"
      ];

      source = [ "~/.config/hypr/main.conf" ];
    };
  };

  xdg.configFile = {
    "hypr/main.conf".source = symlink "${configDir}/hypr/main.conf";
  };

  home.packages = with pkgs; [
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
    swww
    xclip
    wl-clipboard
    cliphist

    ## gui
    gtklock
    wl-color-picker
    grim
    slurp
    swappy

    ## libs
    qt5.qtwayland
    qt6.qtwayland
    xorg.xrandr
    nvidia-vaapi-driver
    libayatana-appindicator
    xdg-utils
    evtest
    glib
  ];
}
