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
    ./hyprpaper
    ./xresources

    (import ./cursors self)
    (import ./qt self)
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "size 1231 950, match:title ^(Open Folder)$"
          "float on     , match:title ^(Open Folder)$"

          "size 1231 950, match:title ^(Open File)$"
          "float on     , match:title ^(Open File)$"
        ];

        layerrule = [
          "no_anim on, match:namespace selection"
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
