{
  pkgs,
  self,
}: let
  apps = import ./apps {inherit pkgs self;};
  devices = import ./devices {inherit pkgs self;};
  packages = import ./packages {inherit pkgs self;};
in
  apps // devices // packages
