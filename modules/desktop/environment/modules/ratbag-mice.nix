{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.selfPackages) libratbag piper;
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
}
