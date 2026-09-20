{buildApp, ...}: let
  inherit (builtins) baseNameOf elem filterSource;
in
  buildApp {
    src = filterSource (filepath: type:
      !(elem (baseNameOf filepath) [
        "lists.json"
      ]))
    ./.;

    npmDepsHash = "sha256-Nk8Nx4zkQ+7D+IRqeEbywEVzdApfkO2Pht609EX0Wpk=";

    runtimeInputs = [];

    meta.description = ''
      Converts a Komga read list into a comics series for reading with mihon.
    '';
  }
