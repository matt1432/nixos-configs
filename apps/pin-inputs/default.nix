{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-c69yfvC/rWlybdesWWyHQm+hv5PTqn/C71h4G+0r1HQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
