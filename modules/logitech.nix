{
  config,
  lib,
  solaar,
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
  imports = [
    solaar.nixosModules.default
  ];

  programs.solaar.enable = true;

  # HOME-MANAGER CONFIG
  home-manager.users.${mainUser} = {
    wayland.windowManager.hyprland = mkIf (cfgHypr.enable) {
      settings.exec-once = ["solaar -w hide -b symbolic"];
    };
  };
}
