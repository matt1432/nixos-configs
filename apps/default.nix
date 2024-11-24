{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe listToAttrs nameValuePair;

  buildApp = attrs: (pkgs.callPackage ./nix/buildApp.nix ({} // inputs // attrs));

  mkApp = file: {
    program = getExe (pkgs.callPackage file ({inherit buildApp;} // inputs));
    type = "app";
  };

  mkApps = apps: listToAttrs (map (x: nameValuePair x (mkApp ./${x})) apps);
in
  mkApps [
    "extract-subs"
    "update-sources"
  ]
