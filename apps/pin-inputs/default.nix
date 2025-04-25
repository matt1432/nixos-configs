{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-3Z5iR8jtU2g42CycUMMYfM3cOa6kKcJwwY3ui94caZY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
