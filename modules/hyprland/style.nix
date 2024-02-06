{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) configDir;
in {
  imports = [../../home/theme.nix];

  home.packages = with pkgs; [swww];

  wayland.windowManager.hyprland = {
    settings = {
      env = ["XCURSOR_SIZE, 24"];

      exec-once = [
        "hyprctl setcursor Dracula-cursors 24"
        "sleep 0.1 && swww init --no-cache && swww img -t none ${pkgs.dracula-theme}/wallpapers/waves.png"
      ];

      windowrule = [
        "size 1231 950,title:^(Open Folder)$"
        "float,title:^(Open Folder)$"

        "size 1231 950,title:^(Open File)$"
        "float,title:^(Open File)$"
      ];

      # This file should only be used for theming
      source = ["${configDir}/hypr/main.conf"];
    };
  };
}
