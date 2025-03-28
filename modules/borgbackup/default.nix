{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.borgbackup;
in {
  imports = [./module.nix];

  config = mkIf (cfg.configs != {}) {
    services.borgbackup = {
      existingRepos = [
        {
          name = "docker";
          host = "nos";
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPijoxuSwH9IrS4poewzHHwe64UoX4QY7Qix5VhEdqKR root@servivi"
          ];
        }

        {
          name = "mc";
          host = "servivi";
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPijoxuSwH9IrS4poewzHHwe64UoX4QY7Qix5VhEdqKR root@servivi"
          ];
        }

        {
          name = "seven-days";
          host = "nos";
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPijoxuSwH9IrS4poewzHHwe64UoX4QY7Qix5VhEdqKR root@servivi"
          ];
        }
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
