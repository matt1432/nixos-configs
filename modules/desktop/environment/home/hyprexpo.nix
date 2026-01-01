self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkBind;

  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      plugins = [pkgs.hyprlandPlugins.hyprexpo];

      settings = {
        plugin.hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

          gesture_distance = 300; # how far is the "max"
        };

        bind = [
          (mkBind {
            modifier = "ALT";
            key = "tab";
            dispatcher = "hyprexpo:expo";
            command = "toggle"; # can be: toggle, off/disable or on/enable
          })
        ];

        hyprexpo-gesture = mkIf cfg.isTouchscreen ["3, vertical, expo"];
      };
    };
  };

  # For accurate stack trace
  _file = ./hyprexpo.nix;
}
