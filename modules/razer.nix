{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
  inherit (lib) mkIf;

  cfgHypr =
    config
    .home-manager
    .users
    .${mainUser}
    .wayland
    .windowManager
    .hyprland;
in {
  hardware.openrazer = {
    enable = true;
    users = [mainUser];
  };

  environment.systemPackages = with pkgs; [
    openrazer-daemon
    polychromatic
  ];

  # HOME-MANAGER CONFIG
  home-manager.users.${mainUser} = {
    wayland.windowManager.hyprland = mkIf (cfgHypr.enable) {
      settings.exec-once = ["polychromatic-tray-applet"];
    };
  };
}
