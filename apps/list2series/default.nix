{buildApp, ...}: let
  inherit (builtins) baseNameOf elem filterSource;
in
  buildApp {
    src = filterSource (filepath: type:
      !(elem (baseNameOf filepath) [
        "lists.json"
      ]))
    ./.;

    npmDepsHash = "sha256-7lrtYPErP2nqH/3P4ydolqbVCMpUP1qIqkJnT0dM7q8=";

    runtimeInputs = [];

    meta.description = ''
      Converts a Komga read list into a comics series for reading with mihon.
    '';
  }
