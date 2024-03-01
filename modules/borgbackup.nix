{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) filterAttrs mapAttrs mkDefault mkOption types;

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
    # TODO: change this to nos
    programs.ssh.knownHosts = {
      pve.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/4mrp8E4Ittwg8feRmPtDHSDR2+Pq4uZHeF5MweVcW";
    };

    services.borgbackup = {
      defaults = {
        environment = mkDefault {BORG_RSH = "ssh -i ${secrets.borg-ssh.path}";};

        # TODO: change this to nos
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

      jobs = let
        tempJobs = mapAttrs (_: v: cfg.defaults // v) cfg.configs;
      in
        mapAttrs (n: v: let
          attrs = filterAttrs (n: _: n != "preHook" || n != "postHook" || n != "paths") v;
          pathPrefix = "/root/snaps";
          snapPath = "${pathPrefix}/${n}";
        in
          attrs
          // {
            paths = map (x: snapPath + x) v.paths;

            preHook =
              v.preHook
              or ""
              +
              /*
              bash
              */
              ''
                if [[ ! -d ${pathPrefix} ]]; then
                    mkdir -p ${pathPrefix}
                fi

                ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r / ${snapPath}
              '';

            postHook =
              /*
              bash
              */
              ''
                ${pkgs.btrfs-progs}/bin/btrfs subvolume delete ${snapPath}
              ''
              + v.postHook or "";
          })
        tempJobs;
    };
  };
}
