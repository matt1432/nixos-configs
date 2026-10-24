{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-oqIkygol1Cf/2nVZvDq0tDgqhj2gpSjk7T+JLjCvzm4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
