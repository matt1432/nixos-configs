self: {
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    inherit (lib) filterAttrs hasPrefix optionals;

    inherit (import ./setupMonitors.nix {inherit config pkgs;}) setupMonitors;

    cfg = config.roles.desktop;

    # Nix stuff
    cfgHypr =
      config
      .home-manager
      .users
      .${cfg.user}
      .wayland
      .windowManager
      .hyprland;

    devices = filterAttrs (n: v: hasPrefix "device:" n) cfgHypr.settings;
  in {
    home-manager.users.greeter = {
      imports = [
        (import ../theme self)
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = cfgHypr.finalPackage;
        systemd.enable = false;

        settings =
          {
            inherit (cfgHypr.settings) cursor input misc monitor;

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

            exec-once = [
              setupMonitors
              "agsGreeter &> /tmp/ags-greetd.log; hyprctl dispatch exit"
            ];
          }
          // devices;
      };
    };
  };

  # For accurate stack trace
  _file = ./hyprland.nix;
}
