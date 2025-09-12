{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-bV9LWbrqTiV+TkWANWzxIbz6ivhI5pU70M9BOna5Bfs=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
