{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./sshd
    ./tailscale
  ];

  options.roles.server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

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
