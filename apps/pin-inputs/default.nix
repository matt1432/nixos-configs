{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7dcFanNxTBXKfHnOdnCBWqKdL27KCS8fjtbzZ4zCWU4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
