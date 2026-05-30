{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-sKB4NRIBh4IbtXpob92umnEMXo0TONNTVRErC97U/l8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
