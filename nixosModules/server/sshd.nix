{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.server;
in {
  config = mkIf cfg.sshd.enable {
    services = {
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    };

    users.users.${cfg.user} = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE39uk52+NIDLdHeoSHIEsOUUFRzj06AGn09z4TUOYm matt@OP9"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICr2+CpqXNMLsjgbrYyIwTKhlVSiIYol1ghBPzLmUpKl matt@binto"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbLu+Gb7PiyNgNXMHemaQLnKixebx1/4cdJGna9OQp matt@wim"
      ];
    };
  };

  # For accurate stack trace
  _file = ./sshd.nix;
}
