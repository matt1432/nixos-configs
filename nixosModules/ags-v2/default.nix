self: {
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    inherit (lib) hasPrefix mkIf removePrefix;

    # Configs
    cfgDesktop = config.roles.desktop;
    flakeDir = config.environment.variables.FLAKE;

    agsConfigDir = "${removePrefix "/home/${cfgDesktop.user}/" flakeDir}/nixosModules/ags-v2/config";
  in
    mkIf cfgDesktop.ags-v2.enable {
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

      home-manager.users.${cfgDesktop.user}.imports = [
        (import ./packages.nix {inherit self agsConfigDir;})
        ./hyprland.nix
      ];
    };

  # For accurate stack trace
  _file = ./default.nix;
}
