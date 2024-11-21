{
  flakePath,
  hostnamePath ? "/etc/hostname",
}: let
  inherit (builtins) currentSystem getFlake head match pathExists readFile removeAttrs;

  hostname =
    if pathExists hostnamePath
    then head (match "([a-zA-Z0-9\\-]+)\n" (readFile hostnamePath))
    else "";

  self =
    if pathExists flakePath
    then
      removeAttrs (getFlake (toString flakePath)) [
        # If you use flakegen, these take a lot of space
        "nextFlake"
        "nextFlakeSource"
      ]
    else {};

  pkgs = self.inputs.nixpkgs.legacyPackages.${currentSystem} or {};
  lib =
    if pkgs != {}
    then {inherit (pkgs) lib;}
    else {};
in
  {inherit lib pkgs self;}
  // self.nixosConfigurations.${hostname}
  or self.nixOnDroidConfigurations.default
  or {}
