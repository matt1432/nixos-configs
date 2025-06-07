{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-OIu/d+vHpzP4V/pJDym9OL5GMZKX4jPV93tZKCjHRo8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
