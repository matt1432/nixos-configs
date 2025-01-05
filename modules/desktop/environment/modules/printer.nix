{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.desktop;
in {
  config = mkIf cfg.enable {
    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;

        drivers = builtins.attrValues {
          inherit
            (pkgs)
            hplip
            samsung-unified-linux-driver
            ;
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./printer.nix;
}
