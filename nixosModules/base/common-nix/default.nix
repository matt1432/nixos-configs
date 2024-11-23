self: {
  config,
  lib,
  ...
}: let
  inherit (lib) hasAttr mkIf optionalString;

  inherit (self.inputs) nixpkgs;
  inherit (config.sops.secrets) access-token;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    # Minimize dowloads of indirect nixpkgs flakes
    nix = {
      registry.nixpkgs.flake = nixpkgs;
      nixPath = ["nixpkgs=${nixpkgs}"];

      extraOptions =
        optionalString (hasAttr "sops" config)
        "!include ${access-token.path}";
    };

    # Global hm settings
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
