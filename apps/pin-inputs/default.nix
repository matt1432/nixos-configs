{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-LgKtEdBeAEcyaiARdPNRB/hSl0Nmlfrv7t4yD2bcB2g=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
