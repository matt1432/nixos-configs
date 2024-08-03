self: {pkgs, ...}: let
  inherit (self.packages.${pkgs.system}) libratbag piper;
in {
  config = {
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
