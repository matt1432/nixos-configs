{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) elem filterAttrs hasAttr;

  packages =
    filterAttrs (
      _: v:
        !(hasAttr "platforms" v.meta)
        || elem pkgs.system v.meta.platforms
    )
    self.packages.${pkgs.system};
in
  packages
