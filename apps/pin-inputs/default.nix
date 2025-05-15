{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-nAPV9iO+sc3oy0ApmuvU/EECumPC8etHcxwCQAR5Xzk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
