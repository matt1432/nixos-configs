{ pkgs, config, hyprland, hyprgrass, ags, ... }: let
  configDir = (import ../vars.nix).configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;

  gset = pkgs.gsettings-desktop-schemas;
  polkit = pkgs.plasma5Packages.polkit-kde-agent;
in
{
  imports = [
    ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    package = ags.packages.x86_64-linux.default;
    configDir = symlink "${configDir}/ags";
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

      exec-once = [ "${polkit}/libexec/polkit-kde-authentication-agent-1" ];
      source = [ "~/.config/hypr/main.conf" ];
    };
  };

  xdg.configFile = {
    "hypr/main.conf".source       = symlink "${configDir}/hypr/main.conf";
    "hypr/hyprpaper.conf".source  = symlink "${configDir}/hypr/hyprpaper.conf";
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
