{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./swayosd.nix)
    (import ./blueberry.nix)
  ];
}
