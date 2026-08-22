{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-N8naVZep6GoWbzepb6xBwgWO7FKMov/GtO0+0by0IeM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
