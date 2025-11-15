{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-h5Xt90vPoB3esuzYvUrIROB+7TxgJwx+TZxLgQB/9jM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
