self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (config.sops) secrets;

  cfg = config.roles.docker;
in {
  imports = [self.inputs.docker-compose.nixosModules.default];

  options.roles.docker = {
    enable = mkOption {
      default = cfg.compositions != {};
      type = types.bool;
      description = ''
        Option to enable docker even without compositions.
      '';
    };

    storageDriver = mkOption {
      default = "btrfs"; # I use BTRFS on all my servers
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        storageDriver = cfg.storageDriver;

        daemon.settings.dns = ["8.8.8.8" "1.1.1.1"];
      };
    };

    # Script for updating the images of a compose.nix file
    environment.systemPackages = [
      (pkgs.callPackage ./updateImage.nix {})
    ];
    nix.settings.extra-sandbox-paths = [secrets.docker.path];
    nixpkgs.overlays = [
      (final: prev: {
        skopeo = pkgs.writeScriptBin "skopeo" ''exec ${prev.skopeo}/bin/skopeo "$@" --authfile=${secrets.docker.path}'';
      })
    ];

    home-manager.users.root.home.file.".docker/config.json".text = ''
      {
        "psFormat": "table {{.ID}}\\t{{.Image}}\\t{{.Names}}\\t{{.Status}}"
      }
    '';
  };

  # For accurate stack trace
  _file = ./default.nix;
}
