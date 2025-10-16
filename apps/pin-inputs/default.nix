{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-PwXvJ4Ma7TJih0xl9aE3bMTOFKYxN5qqjDGcGcZP6J0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
