{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./sshd.nix
    ./tailscale.nix
  ];

  options.roles.server = {
    user = mkOption {
      type = types.str;
      description = ''
        The name of the machine's main user.
      '';
    };

    sshd.enable = mkOption {
      type = types.bool;
      default = false;
    };

    tailscale.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
