{
  config,
  lib,
  nixpkgs,
  ...
}:
with lib; let
  inherit (config.sops.secrets) access-token;
in {
  # Minimize dowloads of indirect nixpkgs flakes
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    nixPath = ["nixpkgs=${nixpkgs}"];
    extraOptions =
      if (hasAttr "sops" config)
      then "!include ${access-token.path}"
      else "";
  };

  # Global hm settings
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
