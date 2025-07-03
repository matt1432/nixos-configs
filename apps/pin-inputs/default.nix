{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-O10djW1GlSho53+uj/pJdbX3LjexDm1T2LanNO2xi/k=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
