{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-upQ2AputqC5LBGeOBP38JBU3T/gEFHPfZdkPhnQkPjE=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
