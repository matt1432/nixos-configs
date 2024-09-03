{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (hass: let
  buildHassAddon = file:
    hass.callPackage file (inputs // {});
in {
  home-llm = buildHassAddon ./home-llm.nix;
})
