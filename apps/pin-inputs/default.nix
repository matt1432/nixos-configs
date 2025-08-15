{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-77GYDWCjLszA1yYwHiU9M+O9ULHSrEhFkXh2nDjh8ZU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
