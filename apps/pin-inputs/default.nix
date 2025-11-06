{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-V18l1tQthzP5bThA5rNp1dV0GnoHDqhdT3nYC6grGeM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
