{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./extra-hardware.nix
    ./security.nix
    ./packages.nix
  ]; 
}
