{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-yy4x44TunP84Hc/QFogfUN1B/h+apuW7rcCUqiDasD0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
