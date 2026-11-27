{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-gqSs8N5QS8fQQK2suBUT+s8KgAyqDuIxPtUXcpL0jaw=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
