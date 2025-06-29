{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-cjb3KFOkkcN9CDSc6qb6CdYIbCHKW44p+7BdT8SxFZs=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
