{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.roles.desktop;
in {
  config = mkIf cfg.enable {
    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;

        drivers = attrValues {
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
