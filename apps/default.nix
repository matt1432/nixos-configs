{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.lib) getExe mapAttrs;

  mkApp = pkg: {
    program = getExe pkg;
    type = "app";
  };
in
  mapAttrs (n: v: mkApp v) self.appsPackages.${pkgs.system}
