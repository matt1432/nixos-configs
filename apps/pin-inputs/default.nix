{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-UbvfCg8TnWGcCzEO7wmiHo2RhELx2HOAB2V0IMmGPEU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
