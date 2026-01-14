{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) elem filterAttrs hasAttr mapAttrs' nameValuePair;

  devShells =
    filterAttrs (
      _: v:
        !(hasAttr "platforms" v.meta)
        || elem pkgs.stdenv.hostPlatform.system v.meta.platforms
    )
    self.devShells.${pkgs.stdenv.hostPlatform.system};
in
  mapAttrs'
  (name: shell:
    nameValuePair "devShell_${name}" shell)
  devShells
