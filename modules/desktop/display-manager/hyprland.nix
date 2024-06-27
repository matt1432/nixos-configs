{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    boolToString
    concatStringsSep
    filterAttrs
    hasPrefix
    isAttrs
    isBool
    mapAttrsToList
    optionalString
    ;

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
  monitors = cfgHypr.settings.monitor;
  inputs = cfgHypr.settings.input;
  misc = cfgHypr.settings.misc;

  mkHyprBlock = attrs:
    concatStringsSep "\n" (mapAttrsToList (
        n: v:
          if (isAttrs v)
          then ''
            ${n} {
            ${mkHyprBlock v}
            }
          ''
          else if (isBool v)
          then "    ${n}=${boolToString v}"
          else "    ${n}=${toString v}"
      )
      attrs);
in {
  hyprConf = pkgs.writeText "greetd-hypr-config" (
    (optionalString config.nvidia.enable
      # hyprlang
      ''
        env = LIBVA_DRIVER_NAME,nvidia
        env = XDG_SESSION_TYPE,wayland
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = WLR_NO_HARDWARE_CURSORS,1
      '')
    + (concatStringsSep "\n" (map (x: "monitor=${x}") monitors))
    + "\n"
    +
    # hyprlang
    ''
      misc {
      ${mkHyprBlock misc}
      }

      # Devices
      ${mkHyprBlock devices}

      input {
      ${mkHyprBlock inputs}
      }

    ''
    +
    # hyprlang
    ''
      #
      env = XCURSOR_SIZE,24
      exec-once = hyprctl setcursor Dracula-cursors 24

      general {
          border_size = 0
      }

      decoration {
          blur {
              enabled = false
          }
          drop_shadow = false
      }

      exec-once = ${setupMonitors}
      exec-once = astal -b greeter &> /tmp/astal.log; hyprctl dispatch exit
    ''
  );
}
