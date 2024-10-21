{
  lib,
  pkgs,
  ...
} @ inputs:
lib.makeScope pkgs.newScope (lovelace: let
  callPackage = file: lovelace.callPackage file ({} // inputs);
in {
  custom-sidebar = callPackage ./custom-sidebar;
  material-symbols = callPackage ./material-symbols;
})