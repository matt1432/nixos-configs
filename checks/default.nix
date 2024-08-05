{
  pkgs,
  self,
}: let
  nixosMachines = import ./machines.nix {inherit pkgs self;};
in
  nixosMachines
