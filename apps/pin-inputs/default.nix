{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-UKLbNG+skFQooy7iaBEyVEUOQ2TWR3EEh/46sfcPp+g=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
