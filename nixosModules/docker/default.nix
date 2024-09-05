khepri: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (config.vars) mainUser;

  cfg = config.khepri;
in {
  imports = [khepri.nixosModules.default];

  options.khepri = {
    rwDataDir = mkOption {
      default = "/var/lib/docker";
      type = types.str;
      description = ''
        Directory to place persistent data in.
      '';
    };

    storageDriver = mkOption {
      default = "btrfs"; # I use BTRFS on all my servers
      type = types.str;
    };
  };

  config = mkIf (cfg.compositions != {}) {
    users.extraUsers.${mainUser}.extraGroups = ["docker"];

    virtualisation = {
      docker = {
        enable = true;
        storageDriver = cfg.storageDriver;

        package = pkgs.docker_27;

        daemon.settings.dns = ["8.8.8.8" "1.1.1.1"];
      };

      # khepri uses oci-containers under the hood and it must be set to docker to work
      oci-containers.backend = "docker";
    };

    # Script for updating the images of all images of a compose.nix file
    environment.systemPackages = [
      (pkgs.callPackage ./updateImage.nix {})
    ];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
