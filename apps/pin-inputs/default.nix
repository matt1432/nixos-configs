{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-E076qhEOIUf+Xd023AihKWhFi2HAsg+/KXNUhKO2q2o=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
