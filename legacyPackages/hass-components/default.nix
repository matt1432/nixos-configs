{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (hass: let
  buildHassComponent = file:
    hass.callPackage file (inputs // {});
in {
  home-llm = buildHassComponent ./home-llm.nix;
})