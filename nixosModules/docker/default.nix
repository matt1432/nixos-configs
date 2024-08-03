khepri: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;

  inherit (config.vars) mainUser;
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
  };

  config = {
    users.extraUsers.${mainUser}.extraGroups = ["docker"];

    virtualisation = {
      docker = {
        enable = true;
        storageDriver = "btrfs";

        package = pkgs.docker_27;

        daemon.settings.dns = ["8.8.8.8" "1.1.1.1"];
      };

      # khepri uses oci-containers under the hood and it must be set to docker to work
      oci-containers.backend = "docker";
    };

    # Script for updating the images of all images of a compose.nix file
    environment.systemPackages = with pkgs; [
      (callPackage ./updateImage.nix {})
    ];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
