{ pkgs, config, hyprland, hyprgrass, ags, ... }: let
  configDir = (import ../vars.nix).configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;

  gset = pkgs.gsettings-desktop-schemas;
  polkit = pkgs.plasma5Packages.polkit-kde-agent;
in
{
  home.packages = with pkgs; [
    sassc
    coloryou
  ];

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
}
