{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hasPrefix mkIf removePrefix;

  # Configs
  cfgDesktop = config.roles.desktop;
  flakeDir = config.environment.variables.FLAKE;

  qsConfigDir = "${removePrefix "/home/${cfgDesktop.user}/" flakeDir}/modules/quickshell/config";
in {
  config = mkIf cfgDesktop.quickshell.enable {
    assertions = [
      {
        assertion = hasPrefix "/home/${cfgDesktop.user}/" flakeDir;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use my quickshell module.
        '';
      }
    ];

    # Machine config
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "quickshell";
        runtimeInputs = [pkgs.quickshell];
        text = ''
          if [ "$#" == 0 ]; then
              exec qs --path ~/${qsConfigDir}
          else
              exec qs "$@"
          fi
        '';
      })
    ];
  };
}
