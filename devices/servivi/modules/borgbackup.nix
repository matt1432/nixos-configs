{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.borgbackup;
  secrets = config.sops.secrets;
in {
  # Make this file declare default settings
  options.services.borgbackup = {
    defaults = mkOption {
      type = types.attrs;
    };
    configs = mkOption {
      type = types.attrs;
    };
  };

  config = {
    users.groups.borg = {};
    users.users.borg = {
      isSystemUser = true;
      # https://mynixos.com/nixpkgs/option/services.borgbackup.jobs.%3Cname%3E.readWritePaths
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
        user = mkDefault "borg";
        environment = mkDefault {BORG_RSH = "ssh -i ${secrets.borg-ssh.path}";};

        repo = mkDefault "ssh://matt@pve/data/backups/borg";
        encryption = mkDefault {
          mode = "repokey";
          passCommand = let
            cat = "${pkgs.coreutils}/bin/cat";
            key = secrets.borg-repo.path;
          in "${cat} ${key}";
        };

        # Run every 3 hours
        startAt = mkDefault "00/3:00";
        compression = mkDefault "auto,lzma";
      };

      jobs = mapAttrs (_: v: cfg.defaults // v) cfg.configs;
    };
  };
}
