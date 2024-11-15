{
  pkgs,
  self,
}: let
  apps = import ./apps.nix {inherit pkgs self;};
  nixosMachines = import ./machines.nix {inherit pkgs self;};
in
  apps // nixosMachines
