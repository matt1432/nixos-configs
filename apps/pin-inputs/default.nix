{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-tzymfxODlgeVHd3neHIzec5lpOrdNN6meCgZavJsSDM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
