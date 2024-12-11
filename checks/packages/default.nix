{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) elem filterAttrs hasAttr mapAttrs' nameValuePair;

  packages =
    filterAttrs (
      _: v:
        !(hasAttr "platforms" v.meta)
        || elem pkgs.system v.meta.platforms
    )
    self.packages.${pkgs.system};
in
  mapAttrs'
  (name: pkg: nameValuePair "pkg_${name}" pkg)
  packages
