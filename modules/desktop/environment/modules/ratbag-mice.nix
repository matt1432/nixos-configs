self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.packages.${pkgs.system}) libratbag piper;
  inherit (lib) mkIf;

  cfg = config.roles.desktop;
in {
  config = mkIf cfg.enable {
    services.ratbagd = {
      enable = true;

      package = libratbag;
    };

    environment.systemPackages = [
      piper
    ];
  };

  # For accurate stack trace
  _file = ./ratbag-mice.nix;
}
