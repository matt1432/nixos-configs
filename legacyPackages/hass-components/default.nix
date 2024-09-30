{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (hass: let
  buildHassComponent = file: extraArgs:
    hass.callPackage file (inputs // extraArgs // {});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation {};
  spotifyplus = import ./spotifyplus ({inherit buildHassComponent;} // inputs);
  tuya-local = buildHassComponent ./tuya-local {};
})
