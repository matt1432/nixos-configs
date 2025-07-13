{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-/XdCUiaaN6+smtLc8dVQ88z1IR/mvZ5zOqZ64Z2fnBU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
