{nixpkgs, ...}: {
  # Minimize dowloads of indirect nixpkgs flakes
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    nixPath = ["nixpkgs=${nixpkgs}"];
  };

  # Global hm settings
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
