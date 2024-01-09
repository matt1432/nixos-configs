{
  config,
  lib,
  nixpkgs,
  ...
}:
with lib; {
  # Minimize dowloads of indirect nixpkgs flakes
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    nixPath = ["nixpkgs=${nixpkgs}"];
    extraOptions = optionalAttrs (hasAttr "sops" config) ''
      !include ${config.sops.secrets.access-token.path}
    '';
  };

  # Global hm settings
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
