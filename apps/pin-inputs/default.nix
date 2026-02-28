{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-/ewTPGRU39uF4xINrxvsilxul2el5aKRk00uRTxYRxc=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
