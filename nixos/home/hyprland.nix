{ pkgs, config, hyprland, hyprgrass, ags, ... }: let
  configDir = (import ../vars.nix).configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = [
    pkgs.sassc
    pkgs.coloryou
  ];

  imports = [
    hyprland.homeManagerModules.default
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

    extraConfig = ''
      env = XDG_DATA_DIRS, ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS

      env = AGS_PATH, ${configDir}/ags/bin
      env = HYPR_PATH, ${configDir}/hypr/scripts
      env = LOCK_PATH, ${configDir}/gtklock/scripts

      exec-once = ${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source = ~/.config/hypr/main.conf
    '';
  };

  xdg.configFile = {
    "hypr/main.conf".source       = symlink "${configDir}/hypr/main.conf";
    "hypr/hyprpaper.conf".source  = symlink "${configDir}/hypr/hyprpaper.conf";
  };
}
