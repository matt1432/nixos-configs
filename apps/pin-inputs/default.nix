{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-I0jJrKPQNtkiFhVa2vQc4C3T2U0mtt59jlWdmavc8xM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
