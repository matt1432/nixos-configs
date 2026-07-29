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
        window_rule = [
          {
            match.title = "^(Open Folder)$";
            size = "1231 950";
            float = true;
          }

          {
            match.title = "^(Open File)$";
            size = "1231 950";
            float = true;
          }
        ];

        layer_rule = [
          {
            match.namespace = "selection";
            no_anim = true;
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
