{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) all any attrValues findSingle length mapAttrs mkIf mkOption types;
  inherit (builtins) filter hasAttr listToAttrs removeAttrs;

  inherit (config.sops) secrets;
  inherit (config.vars) hostName;

  cfg = config.services.borgbackup;
in {
  options.services.borgbackup = {
    configs = mkOption {
      # Taken from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/backup/borgbackup.nix
      type = types.attrsOf (types.submodule (
        let
          globalConfig = config;
        in
          {
            name,
            config,
            ...
          }: {
            options = {
              paths = mkOption {
                type = types.nullOr (types.coercedTo types.str lib.singleton (types.listOf types.str));
                default = null;
              };
              dumpCommand = mkOption {
                type = with types; nullOr path;
                default = null;
              };
              repo = mkOption {
                type = types.str;
                default = name;
              };
              removableDevice = mkOption {
                type = types.bool;
                default = false;
              };
              archiveBaseName = mkOption {
                type = types.nullOr (types.strMatching "[^/{}]+");
                default = "${globalConfig.networking.hostName}-${name}";
              };
              dateFormat = mkOption {
                type = types.str;
                default = "+%Y-%m-%dT%H:%M:%S";
              };
              startAt = mkOption {
                type = with types; either str (listOf str);
                # Run every 3 hours
                default = "00/3:00";
              };
              persistentTimer = mkOption {
                default = false;
                type = types.bool;
              };
              inhibitsSleep = mkOption {
                default = false;
                type = types.bool;
              };
              user = mkOption {
                type = types.str;
                default = "root";
              };
              group = mkOption {
                type = types.str;
                default = "root";
              };
              encryption.mode = mkOption {
                type = types.enum [
                  "repokey"
                  "keyfile"
                  "repokey-blake2"
                  "keyfile-blake2"
                  "authenticated"
                  "authenticated-blake2"
                  "none"
                ];
                default = "none";
              };
              encryption.passCommand = mkOption {
                type = with types; nullOr str;
                default = null;
              };
              encryption.passphrase = mkOption {
                type = with types; nullOr str;
                default = null;
              };
              compression = mkOption {
                type = types.strMatching "none|(auto,)?(lz4|zstd|zlib|lzma)(,[[:digit:]]{1,2})?";
                default = "auto,lz4";
              };
              exclude = mkOption {
                type = with types; listOf str;
                default = [];
              };
              patterns = mkOption {
                type = with types; listOf str;
                default = [];
              };
              readWritePaths = mkOption {
                type = with types; listOf path;
                default = [];
              };
              privateTmp = mkOption {
                type = types.bool;
                default = true;
              };
              doInit = mkOption {
                type = types.bool;
                default = true;
              };
              appendFailedSuffix = mkOption {
                type = types.bool;
                default = true;
              };
              prune.keep = mkOption {
                type = with types; attrsOf (either int (strMatching "[[:digit:]]+[Hdwmy]"));
                default = {};
              };
              prune.prefix = mkOption {
                type = types.nullOr (types.str);
                default = config.archiveBaseName;
              };
              environment = mkOption {
                type = with types; attrsOf str;
                default = {};
              };
              preHook = mkOption {
                type = types.lines;
                default = "";
              };
              postInit = mkOption {
                type = types.lines;
                default = "";
              };
              postCreate = mkOption {
                type = types.lines;
                default = "";
              };
              postPrune = mkOption {
                type = types.lines;
                default = "";
              };
              postHook = mkOption {
                type = types.lines;
                default = "";
              };
              extraArgs = mkOption {
                type = types.str;
                default = "";
              };
              extraInitArgs = mkOption {
                type = types.str;
                default = "";
              };
              extraCreateArgs = mkOption {
                type = types.str;
                default = "";
              };
              extraPruneArgs = mkOption {
                type = types.str;
                default = "";
              };
              extraCompactArgs = mkOption {
                type = types.str;
                default = "";
              };
            };
          }
      ));
      default = {};
    };

    existingRepos = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          host = mkOption {
            type = types.str;
          };
          authorizedKeys = mkOption {
            type = types.listOf types.str;
            default = [];
          };
        };
      });
      default = [];
    };
  };

  config = mkIf (cfg.configs != {}) {
    assertions = [
      {
        assertion = all (
          conf:
            any (repo: conf.repo == repo.name) cfg.existingRepos
        ) (attrValues cfg.configs);
        message = ''
          The  repo you want to backup to needs to exist.
        '';
      }
    ];

    services.borgbackup = let
      backupDir = {
        nos = "/data/borgbackups";
        servivi = "/home/backups";
      };
    in {
      repos =
        mkIf (length cfg.existingRepos > 0)
        (listToAttrs (map (r: {
            inherit (r) name;
            value = {
              authorizedKeysAppendOnly = r.authorizedKeys;
              path = "${backupDir.${hostName}}/${r.name}";
            };
          })
          (filter (x: x.host == hostName) cfg.existingRepos)));

      jobs = mapAttrs (n: v: let
        existingRepo = findSingle (x: x.name == v.repo) null null cfg.existingRepos;
        otherAttrs = removeAttrs v [
          "environment"
          "paths"
          "preHook"
          "postHook"
          "repo"
        ];
        pathPrefix = "/root/snaps";
        snapPath = "${pathPrefix}/${n}";
      in
        {
          environment =
            v.environment
            // (mkIf (hasAttr "borg-ssh" secrets) {
              BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i ${secrets.borg-ssh.path}";
            });

          paths = map (x: snapPath + x) v.paths;

          preHook =
            v.preHook
            + ''
              if [[ ! -d ${pathPrefix} ]]; then
                  mkdir -p ${pathPrefix}
              fi

              ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r / ${snapPath}
            '';

          postHook =
            v.postHook
            + ''
              ${pkgs.btrfs-progs}/bin/btrfs subvolume delete ${snapPath}
            '';

          repo =
            if (hostName != existingRepo.host)
            then "ssh://borg@${existingRepo.host}${backupDir.${existingRepo.host}}/${v.repo}"
            else "${backupDir.${existingRepo.host}}/${v.repo}";
        }
        // otherAttrs)
      cfg.configs;
    };
  };

  # For accurate stack trace
  _file = ./module.nix;
}
