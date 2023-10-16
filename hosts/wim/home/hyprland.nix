{ pkgs, config, hyprland, hyprgrass, ags, nixpkgs-wayland, ... }: let
  waypkgs = nixpkgs-wayland.packages.x86_64-linux;

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
    "hypr/main.conf".source    = symlink "${configDir}/hypr/main.conf";

    "hypr/hyprpaper.conf".text = ''
      preload = ${pkgs.dracula-theme}/wallpapers/waves.png
      wallpaper = eDP-1, ${pkgs.dracula-theme}/wallpapers/waves.png
    '';
  };

  home.packages = [
    # ags
    pkgs.sassc
    pkgs.coloryou
    pkgs.libnotify
    pkgs.playerctl
    pkgs.bluez-tools
    pkgs.brightnessctl
    pkgs.pulseaudio
    pkgs.libinput

    ## gui
    pkgs.pavucontrol # TODO: replace with ags widget
    pkgs.networkmanagerapplet # TODO: replace with ags widget
    pkgs.blueberry # TODO: replace with ags widget


    # Hyprland
    pkgs.hyprpaper
    waypkgs.swayidle
    pkgs.lisgd
    pkgs.swayosd
    pkgs.squeekboard
    pkgs.xclip
    waypkgs.wl-clipboard
    pkgs.cliphist

    ## gui
    pkgs.gtklock
    pkgs.wl-color-picker # TODO: add bind for this in hyprland
    waypkgs.grim
    waypkgs.slurp
    pkgs.swappy

    ## libs
    pkgs.libayatana-appindicator
    pkgs.xdg-utils
    pkgs.evtest
    pkgs.glib
  ];
}
