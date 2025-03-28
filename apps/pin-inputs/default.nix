{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-O5rNGEtBoH4itUjUG9dX3EPAEGYkQxPz1FePohLLKuA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
