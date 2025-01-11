{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair;

  devices =
    filterAttrs
    (n: config: config.pkgs.system == pkgs.system)
    self.nixosConfigurations;
in
  mapAttrs'
  (name: config:
    nameValuePair "device_${name}" config.config.system.build.toplevel)
  devices
