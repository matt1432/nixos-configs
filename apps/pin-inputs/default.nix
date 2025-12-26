{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-RzFGvCvQciKsyw8NjaGVDZ/aAofwhL6if7aEj7mJA2c=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
