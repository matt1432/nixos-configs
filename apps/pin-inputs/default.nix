{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-dmf5bO1yLKUOBx+hqD7agK8F5ftHNc7KY6L8TeB2N48=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
