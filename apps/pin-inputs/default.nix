{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-eos8TiogqSGD2hcRSlcLppYtjuP8LtCTf0TPNPjKIrk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
