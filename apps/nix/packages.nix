{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.lib) mapAttrs removeSuffix;
in
  mapAttrs (
    name: app: (pkgs.symlinkJoin {
      name = "app-${name}";
      paths = [(removeSuffix "/bin/${name}" (toString app.program))];
    })
  )
  (removeAttrs self.apps.${pkgs.system} ["genflake"])
