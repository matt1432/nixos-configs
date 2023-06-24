{ pkgs, ... }: let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
                                           # I use release version for plugin support
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;

in
{
  home.packages = [
    (builtins.getFlake "github:hyprwm/Hyprland").packages.x86_64-linux.default
    (builtins.getFlake "path:/home/matt/git/hyprland-touch-gestures").packages.x86_64-linux.default
  ];

  home.sessionVariables = {
    XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:\$XDG_DATA_DIRS";
  };

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
      exec-once = ${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source = ~/.config/hypr/main.conf
      env = XDG_DATA_DIRS, ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
      env = SUDO_ASKPASS, ${pkgs.plasma5Packages.ksshaskpass}/bin/${pkgs.plasma5Packages.ksshaskpass.pname}
    '';
  };
}
