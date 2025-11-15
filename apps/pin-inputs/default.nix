{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-eHyZiHQbm4WD6wPg9Qrn0Zh0SMi7kxdKK10DGcCClSM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
