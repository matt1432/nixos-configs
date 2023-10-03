{ pkgs, config, hyprland, hyprgrass, ags, ... }: let
  configDir = "/home/matt/.nix/config";
in
{
  home.packages = [
    pkgs.sassc
    pkgs.flat-remix-icon-theme
    pkgs.coloryou
  ];

  imports = [
    hyprland.homeManagerModules.default
    ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    package = ags.packages.x86_64-linux.default;
    configDir = config.lib.file.mkOutOfStoreSymlink "${configDir}/ags";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.x86_64-linux.default;

    plugins = [
      "${hyprgrass.packages.x86_64-linux.default}/lib/libhyprgrass.so"
    ];

    extraConfig = ''
      env = XDG_DATA_DIRS, ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS

      env = AGS_PATH, ${configDir}/ags/bin
      env = HYPR_PATH, ${configDir}/hypr/scripts
      env = LOCK_PATH, ${configDir}/gtklock/scripts

      exec-once = ${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source = ~/.config/hypr/main.conf
    '';
  };

  # https://www.reddit.com/r/NixOS/comments/vc3srj/comment/iccqxw1/?utm_source=share&utm_medium=web2x&context=3
  xdg.configFile = {
    "../.themes/Dracula".source   = "${pkgs.dracula-theme}/share/themes/Dracula";

    "Kvantum/Dracula".source              = "${pkgs.dracula-theme}/share/Kvantum/Dracula";
    "Kvantum/Dracula-Solid".source        = "${pkgs.dracula-theme}/share/Kvantum/Dracula-Solid";
    "Kvantum/Dracula-purple".source       = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple";
    "Kvantum/Dracula-purple-solid".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid";

    "hypr/main.conf".source       = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr/main.conf";
    "hypr/hyprpaper.conf".source  = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr/hyprpaper.conf";
  };
}
