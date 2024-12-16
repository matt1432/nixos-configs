{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) mapAttrs' nameValuePair;
in
  mapAttrs'
  (name: shell:
    nameValuePair "devShell_${name}" shell)
  self.devShells.${pkgs.system}
