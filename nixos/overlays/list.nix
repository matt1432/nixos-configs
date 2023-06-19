{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./swayosd.nix)
  ];
}
