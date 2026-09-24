self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hasAttr mkIf mkOption optionals types;
  inherit (config.sops) secrets;

  hasSecrets = optionals (hasAttr "sops" config);

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
      type = types.nullOr types.str;
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
    environment.systemPackages = hasSecrets [
      (pkgs.callPackage ./updateImage.nix {})
    ];
    nix.settings.extra-sandbox-paths = hasSecrets [secrets.docker.path];
    nixpkgs.overlays = hasSecrets [
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
