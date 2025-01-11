{
  lib,
  pkgs,
  self,
  ...
} @ inputs:
lib.makeScope pkgs.newScope (hass: let
  inherit (self.lib) mergeAttrsList;

  python3Packages = pkgs.python312Packages.override {
    overrides = final: prev: (mergeAttrsList (map (x: x python3Packages final prev) [
      (import ./spotifyplus/overrides.nix ({inherit pkgs;} // inputs))
      (import ./tuya-local/overrides.nix {inherit pkgs;})
    ]));
  };

  buildHassComponent = file: extraArgs:
    hass.callPackage file (inputs // extraArgs // {inherit python3Packages;});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation {};

  ha-fallback-conversation = buildHassComponent ./ha-fallback-conversation {};

  material-symbols = buildHassComponent ./material-symbols {};

  netdaemon = buildHassComponent ./netdaemon {};

  spotifyplus = buildHassComponent ./spotifyplus {};

  tuya-local = buildHassComponent ./tuya-local {};

  yamaha-soundbar = buildHassComponent ./yamaha-soundbar {};
})
