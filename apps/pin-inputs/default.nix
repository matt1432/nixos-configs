{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-1qjRkp8gcres34VJpN+TvrByEXtv26bmsiMYnGHrWd4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
