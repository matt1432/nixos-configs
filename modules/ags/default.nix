self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) ags astal virtualkeyboard-adapter;
  inherit (lib) hasPrefix mkIf removePrefix;

  # Configs
  cfgDesktop = config.roles.desktop;
  flakeDir = config.environment.variables.FLAKE;

  agsConfigDir = "${removePrefix "/home/${cfgDesktop.user}/" flakeDir}/modules/ags/config";

  hmOpts = {lib, ...}: {
    options.programs.ags = {
      package = lib.mkOption {
        type = with lib.types; nullOr package;
        default = null;
      };

      astalLibs = lib.mkOption {
        type = with lib.types; nullOr (listOf package);
        default = null;
      };

      lockPkg = lib.mkOption {
        type = with lib.types; nullOr package;
        default = null;
      };

      configDir = lib.mkOption {
        type = lib.types.str;
        default = agsConfigDir;
      };
    };
  };
in {
  config = mkIf cfgDesktop.ags.enable {
    assertions = [
      {
        assertion = hasPrefix "/home/${cfgDesktop.user}/" flakeDir;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use the AGS module.
        '';
      }
    ];

    # Machine config
    security.pam.services.astal-auth = {};
    services.upower.enable = true;

    nixpkgs.overlays = [
      ags.overlays.default
      astal.overlays.default
      virtualkeyboard-adapter.overlays.default
    ];

    i18n.inputMethod = mkIf cfgDesktop.isTouchscreen {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;
        addons = [
          (pkgs.virtualkeyboard-adapter.overrideAttrs (o: {
            # FIXME: make PR
            cmakeFlags = o.cmakeFlags or [] ++ ["-DCMAKE_CXX_STANDARD=20"];
            postPatch = ''
              ${o.postPatch or ""}
              substituteInPlace ./CMakeLists.txt --replace-fail \
                  'cmake_minimum_required(VERSION 3.6)' \
                  'cmake_minimum_required(VERSION 3.10)'
            '';
          }))
        ];
      };
    };

    home-manager.users.${cfgDesktop.user}.imports = [
      hmOpts
      (import ./packages.nix self)
      (import ./hyprland.nix self)
    ];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
