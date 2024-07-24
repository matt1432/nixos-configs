{
  config,
  khepri,
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
      };
      # khepri uses oci-containers under the hood and it must be set to docker to work
      oci-containers.backend = "docker";
    };

    # Script for updating the images of all images of a compose.nix file
    environment.systemPackages = with pkgs; [
      (callPackage ./updateImage.nix {})
    ];
  };
}
