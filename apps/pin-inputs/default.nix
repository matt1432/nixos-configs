{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-YQLIDcjIIi6bQ5j9nahT/aLXyR0n/6j/EyW7SUzM/5Y=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
