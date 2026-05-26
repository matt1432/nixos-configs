self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) nixpkgs determinate-nix;

  inherit (lib) hasAttr mkIf optionalString;

  inherit (config.sops.secrets) access-token;

  cfg = config.roles.base;

  usingDetSys = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
in {
  config = mkIf cfg.enable {
    nix = {
      package =
        if usingDetSys
        then determinate-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
        else pkgs.nixVersions.latest;

      # Minimize dowloads of indirect nixpkgs flakes
      registry.nixpkgs.flake = nixpkgs;
      nixPath = ["nixpkgs=${nixpkgs}"];

      extraOptions =
        optionalString (hasAttr "sops" config)
        "!include ${access-token.path}";

      settings = mkIf usingDetSys {
        # DeterminateSystems settings
        lazy-trees = true;
        eval-cores = 0;
      };
    };

    # Global hm settings
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
