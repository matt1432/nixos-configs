{
  config,
  lib,
  pkgs,
  ...
}: {
  # Make this file declare default settings
  options.services.borgbackup = with lib; {
    defaults = mkOption {
      type = types.attrs;
    };
  };

  config = {
    users.groups.borg = {};
    users.users.borg = {
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/borg";
      group = "borg";
      extraGroups = ["mc"];
    };

    programs.ssh.knownHosts = {
      pve.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/4mrp8E4Ittwg8feRmPtDHSDR2+Pq4uZHeF5MweVcW";
    };

    services.borgbackup = {
      defaults = {
        user = "borg";
        environment = {
          # TODO: use secrets
          BORG_RSH = "ssh -i ${config.users.users.borg.home}/.ssh/id_ed25519";
        };

        repo = "ssh://matt@pve/data/backups/borg";
        encryption = {
          mode = "repokey";
          passCommand = let
            cat = "${pkgs.coreutils}/bin/cat";
            key = config.sops.secrets.borg-repo.path;
          in "${cat} ${key}";
        };

        # Run every 3 hours
        startAt = "00/3:00";
        compression = "auto,lzma";
      };
    };
  };
}
