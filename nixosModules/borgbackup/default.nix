{...}: {
  imports = [./module.nix];

  config.services.borgbackup = {
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
        host = "nos";
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

  # For accurate stack trace
  _file = ./default.nix;
}
