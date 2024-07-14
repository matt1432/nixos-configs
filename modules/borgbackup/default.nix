{...}: {
  imports = [./module.nix];

  services.borgbackup = {
    existingRepos = [
      {
        name = "arion";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPijoxuSwH9IrS4poewzHHwe64UoX4QY7Qix5VhEdqKR root@servivi"
        ];
      }

      {
        name = "mc";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPijoxuSwH9IrS4poewzHHwe64UoX4QY7Qix5VhEdqKR root@servivi"
        ];
      }

      {
        name = "seven-days";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPijoxuSwH9IrS4poewzHHwe64UoX4QY7Qix5VhEdqKR root@servivi"
        ];
      }
    ];
  };
}
