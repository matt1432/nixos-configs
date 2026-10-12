{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-u4ThNEW14zLkev47T/72IUsZa4q4ytfAYDn2SRK/ShU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
