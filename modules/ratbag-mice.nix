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
  services.ratbagd.enable = true;

  # HOME-MANAGER CONFIG
  home-manager.users.${mainUser} = {
    home.packages = with pkgs; [piper];

    wayland.windowManager.hyprland = mkIf (cfgHypr.enable) {
      # settings.exec-once = [""];
    };
  };
}
