{
  config,
  lib,
  nixpkgs,
  ...
}: let
  inherit (config.sops.secrets) access-token;
  inherit (lib) hasAttr optionalString;
in {
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
}
