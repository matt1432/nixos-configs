{
  lib,
  pkgs,
  self,
  ...
} @ inputs:
lib.makeScope pkgs.newScope (hass: let
  inherit (self.lib) mergeAttrsList;

  python3Packages = pkgs.python313Packages.override {
    overrides = final: prev: (mergeAttrsList (map (fn: fn python3Packages final prev) [
      (import ./spotifyplus/overrides.nix ({inherit pkgs;} // inputs))
      (import ./tuya-local/overrides.nix {inherit pkgs;})
    ]));
  };

  buildHassComponent = file: extraArgs:
    python3Packages.callPackage file (inputs // extraArgs // {});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation {};

  material-symbols = buildHassComponent ./material-symbols {};

  netdaemon = buildHassComponent ./netdaemon {};

  spotifyplus = buildHassComponent ./spotifyplus {};

  tuya-local = buildHassComponent ./tuya-local {};

  yamaha-soundbar = buildHassComponent ./yamaha-soundbar {};
})
