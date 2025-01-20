{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe listToAttrs nameValuePair;

  buildApp = attrs: (pkgs.callPackage ./buildApp.nix ({} // inputs // attrs));

  mkNodeApp = file: {
    program = getExe (pkgs.callPackage file ({inherit buildApp;} // inputs));
    type = "app";
  };

  mkNodeApps = apps: listToAttrs (map (x: nameValuePair x (mkNodeApp ./${x})) apps);
in
  mkNodeApps [
    "extract-subs"
    "update-sources"
  ]
  // {
    gen-docs = {
      program = getExe (pkgs.callPackage ./gen-docs {});
      type = "app";
    };
  }
