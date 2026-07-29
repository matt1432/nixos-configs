self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.hypr) mkEnvs mkExecOnce;

  inherit (lib) mkIf optionalAttrs;

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

        configType = "lua";

        settings = {
          inherit (cfgHypr.settings) device monitor;

          config = {
            inherit (cfgHypr.settings.config) cursor ecosystem input misc;

            general.border_size = 0;

            decoration = {
              blur.enabled = false;
              shadow.enabled = false;
            };
          };

          env = mkEnvs (optionalAttrs config.nvidia.enable {
            LIBVA_DRIVER_NAME = "nvidia";
            XDG_SESSION_TYPE = "wayland";
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          });

          animation = [
            {
              leaf = "fadeLayersIn";
              enabled = false;
            }
            {
              leaf = "layers";
              enabled = true;
              speed = 4;
              bezier = "default";
              style = "popin";
            }
          ];

          on = map mkExecOnce [
            # lua
            ''
              hl.exec_cmd("${setupMonitors}")
              hl.exec_cmd("agsGreeter &> /tmp/ags-greetd.log; hyprctl dispatch 'hl.dsp.exit()'")
            ''
          ];
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
