{
  lib,
  pkgs,
  ...
} @ inputs:
lib.makeScope pkgs.newScope (hass: let
  buildHassComponent = file: extraArgs:
    hass.callPackage file (inputs // extraArgs // {});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation {};
  ha-fallback-conversation = buildHassComponent ./ha-fallback-conversation {};
  material-symbols = buildHassComponent ./material-symbols {};
  netdaemon = buildHassComponent ./netdaemon {};
  spotifyplus = import ./spotifyplus ({inherit buildHassComponent;} // inputs);
  tuya-local = buildHassComponent ./tuya-local {};
  yamaha-soundbar = buildHassComponent ./yamaha-soundbar {};
})
