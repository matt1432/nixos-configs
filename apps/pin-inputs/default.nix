{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-rkK+jTxVJDotaq8Gkgw86weA5QJWHDMG5ExSUXfYV4Q=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
