{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-4tdkwSCOcxzLXcOjbYH3vrZjb4MIFmfb32aWgWauzgs=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
