self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (self.inputs) nix-index-db;

  cfg = config.programs.bash;
in {
  imports = [nix-index-db.hmModules.nix-index];

  config.programs = mkIf cfg.enable {
    direnv = {
      enable = true;
      enableBashIntegration = true;

      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };

    nix-index-database.comma.enable = true;

    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
