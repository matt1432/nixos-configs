{inputs, ...}: (final: prev: {
  appsPackages = let
    inherit (final.lib) listToAttrs nameValuePair;

    buildApp = attrs: (final.callPackage ./buildApp.nix ({} // inputs // attrs));
    callPackage = file: final.callPackage file ({inherit buildApp;} // inputs);
  in
    listToAttrs (map (x: nameValuePair x (callPackage ./${x})) [
      "extract-subs"
      "gen-docs"
      "mc-mods"
      "pin-inputs"
      "update-sources"
    ]);
})
