{ pkgs, config, ... }: let

  configDir = "/home/matt/.nix/config";

  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;

in
{
  home.packages = [
    (builtins.getFlake "github:hyprwm/Hyprland").packages.x86_64-linux.default
    (builtins.getFlake "path:/home/matt/git/hyprland-touch-gestures").packages.x86_64-linux.default
    pkgs.kora-icon-theme
  ];

  imports = [
   hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = (builtins.getFlake "github:hyprwm/Hyprland").packages.x86_64-linux.default; # to be able to get the right ver from hyprctl version
    
    plugins = [
      "${(builtins.getFlake "path:/home/matt/git/hyprland-touch-gestures").packages.x86_64-linux.default}/lib/libtouch-gestures.so"
    ];

    extraConfig = ''
      env = XDG_DATA_DIRS, ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
      $kora = "$HOME/.config/share"

      env = EWW_PATH, ${configDir}/eww/scripts
      env = HYPR_PATH, ${configDir}/hypr/scripts
      env = LOCK_PATH, ${configDir}/gtklock/scripts

      exec-once = ${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source = ~/.config/hypr/main.conf
    '';
  };

  # https://www.reddit.com/r/NixOS/comments/vc3srj/comment/iccqxw1/?utm_source=share&utm_medium=web2x&context=3
  xdg.configFile = {
    "share/icons/hicolor".source  = "${pkgs.kora-icon-theme}/share/icons/kora-pgrey";
    "../.themes/Dracula".source   = "${pkgs.dracula-theme}/share/themes/Dracula";

    "Kvantum/Dracula".source              = "${pkgs.dracula-theme}/share/Kvantum/Dracula";
    "Kvantum/Dracula-Solid".source        = "${pkgs.dracula-theme}/share/Kvantum/Dracula-Solid";
    "Kvantum/Dracula-purple".source       = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple";
    "Kvantum/Dracula-purple-solid".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid";

    "hypr/main.conf".source       = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr/main.conf";
    "hypr/hyprpaper.conf".source  = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr/hyprpaper.conf";
  };
}
