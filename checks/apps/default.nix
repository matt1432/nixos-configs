{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) mapAttrs' nameValuePair;
in
  mapAttrs'
  (name: app:
    nameValuePair "app_${name}" app)
  self.appsPackages.${pkgs.system}
