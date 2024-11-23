self: {lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    (import ./common-nix self)
    (import ./packages self)
  ];

  options.roles.base = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    user = mkOption {
      type = types.str;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
