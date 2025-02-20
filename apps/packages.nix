{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) listToAttrs nameValuePair;

  buildApp = attrs: (pkgs.callPackage ./buildApp.nix ({} // inputs // attrs));
  callPackage = file: pkgs.callPackage file ({inherit buildApp;} // inputs);
in
  listToAttrs (map (x: nameValuePair x (callPackage ./${x})) [
    "extract-subs"
    "gen-docs"
    "mc-mods"
    "pin-inputs"
    "update-sources"
  ])
