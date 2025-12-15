{buildApp, ...}: let
  inherit (builtins) baseNameOf elem filterSource;
in
  buildApp {
    src = filterSource (filepath: type:
      !(elem (baseNameOf filepath) [
        "lists.json"
      ]))
    ./.;

    npmDepsHash = "sha256-4OFB32uDW0ji7ANcCbpgnaxeZrQt48A1bGfzmVwQBTE=";

    runtimeInputs = [];

    meta.description = ''
      Converts a Komga read list into a comics series for reading with mihon.
    '';
  }
