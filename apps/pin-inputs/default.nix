{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Acwb7P2pieMVLI/bpHV/uwazQuhxJC9WTgg1cFhzYyM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
