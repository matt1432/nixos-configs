self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkAnimation;

  inherit (lib) mkIf optionals;

  inherit (import ./setupMonitors.nix {inherit config pkgs;}) setupMonitors;

  cfg = config.roles.desktop;

  cfgHypr =
    config
    .home-manager
    .users
    .${cfg.user}
    .wayland
    .windowManager
    .hyprland;
in {
  config = mkIf cfg.enable {
    home-manager.users.greeter = {
      imports = [
        (import ../../theme self)
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;

        package = cfgHypr.finalPackage;

        settings = {
          inherit (cfgHypr.settings) cursor device input misc monitor;

          envd = optionals (config.nvidia.enable) [
            "LIBVA_DRIVER_NAME, nvidia"
            "NVD_BACKEND, direct"
            "XDG_SESSION_TYPE, wayland"
            "GBM_BACKEND, nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME, nvidia"
          ];

          general.border_size = 0;

          decoration = {
            blur.enabled = false;
            shadow.enabled = false;
          };

          animation = map mkAnimation [
            {
              name = "fadeLayersIn";
              enable = false;
            }
            {
              name = "layers";
              duration = 4;
              style = "popin";
            }
          ];

          exec-once = [
            setupMonitors
            "agsGreeter &> /tmp/ags-greetd.log; hyprctl dispatch exit"
          ];
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
