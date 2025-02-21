{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-IconCxfIK4GIgRlaw8zv1RJreDCJQC02ve/Uf/35nPI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
