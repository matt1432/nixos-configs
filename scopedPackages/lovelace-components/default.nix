{
  lib,
  pkgs,
  ...
} @ inputs:
lib.makeScope pkgs.newScope (lovelace: let
  callPackage = file: lovelace.callPackage file ({} // inputs);
in {
  big-slider-card = callPackage ./big-slider-card;
  custom-sidebar = callPackage ./custom-sidebar;
  material-rounded-theme = callPackage ./material-rounded-theme;
  material-you-utilities = callPackage ./material-you-utilities;
})
