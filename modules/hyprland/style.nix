{config, ...}: let
  inherit (config.vars) configDir;
in {
  imports = [
    ../../home/theme
    ../../home/wpaperd.nix
  ];

  wayland.windowManager.hyprland = {
    settings = {
      envd = ["XCURSOR_SIZE, 24"];

      exec-once = [
        "hyprctl setcursor Dracula-cursors 24"
        "wpaperd -d"
      ];

      windowrule = [
        "size 1231 950,title:^(Open Folder)$"
        "float,title:^(Open Folder)$"

        "size 1231 950,title:^(Open File)$"
        "float,title:^(Open File)$"
      ];

      layerrule = [
        "noanim, selection"
      ];

      # This file should only be used for theming
      source = ["${configDir}/hypr/main.conf"];
    };
  };
}
