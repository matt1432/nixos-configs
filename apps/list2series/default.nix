{buildApp, ...}: let
  inherit (builtins) baseNameOf elem filterSource;
in
  buildApp {
    src = filterSource (filepath: type:
      !(elem (baseNameOf filepath) [
        "lists.json"
      ]))
    ./.;

    npmDepsHash = "sha256-ZcPm4Me8BPx+ZRJvXE98SF17ZCV5WZhwXg+P0ktYiDU=";

    runtimeInputs = [];

    meta.description = ''
      Converts a Komga read list into a comics series for reading with mihon.
    '';
  }
