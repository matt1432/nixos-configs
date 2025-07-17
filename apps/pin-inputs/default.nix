{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-c4GaVDHu0s9gGhgWLKMIr6YU/xlG4QRphRmIM5J9zT0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
