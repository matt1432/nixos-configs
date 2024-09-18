{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (hass: let
  buildHassComponent = file:
    hass.callPackage file (inputs // {});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation.nix;
})
