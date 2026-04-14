{buildApp, ...}: let
  inherit (builtins) baseNameOf elem filterSource;
in
  buildApp {
    src = filterSource (filepath: type:
      !(elem (baseNameOf filepath) [
        "lists.json"
      ]))
    ./.;

    npmDepsHash = "sha256-DOzMUdV8QCC+epW3H4HZssLvpons1QDqKbvnBd+XZS4=";

    runtimeInputs = [];

    meta.description = ''
      Converts a Komga read list into a comics series for reading with mihon.
    '';
  }
