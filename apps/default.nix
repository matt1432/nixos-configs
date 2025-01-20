{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.lib) getExe mapAttrs' nameValuePair removePrefix;

  mkApp = pkg: {
    program = getExe pkg;
    type = "app";
  };
in
  mapAttrs' (
    n: v:
      nameValuePair (removePrefix "app-" n) (mkApp v)
  )
  self.appsPackages.${pkgs.system}
