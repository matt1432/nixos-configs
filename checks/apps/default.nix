{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) mapAttrs' nameValuePair removeAttrs removeSuffix;
in
  mapAttrs'
  (name: app:
    nameValuePair "app-${name}" (pkgs.symlinkJoin {
      name = "app-${name}";
      paths = [(removeSuffix "/bin/${name}" (toString app.program))];
    }))
  (removeAttrs self.apps.${pkgs.system} ["genflake"])
