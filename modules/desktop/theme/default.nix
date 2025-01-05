self: {
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  imports = [
    ./gtk
    ./xresources

    (import ./cursors self)
    (import ./hyprpaper self)
    (import ./qt self)
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "size 1231 950,title:^(Open Folder)$"
          "float,title:^(Open Folder)$"

          "size 1231 950,title:^(Open File)$"
          "float,title:^(Open File)$"
        ];

        layerrule = [
          "noanim, selection"
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
