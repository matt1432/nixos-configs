{
  pkgs,
  self,
}: let
  apps = import ./apps {inherit pkgs self;};
  devices = import ./devices {inherit pkgs self;};
  packages = import ./packages {inherit pkgs self;};
in {
  # Allow homie to serve a binary cache for the devices away from servivi
  aptDevices = import ./devices {
    onlyApt = true;
    inherit pkgs self;
  };

  all = apps // devices // packages;
  inherit apps packages devices;
}
