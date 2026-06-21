{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-uvBwR99l9MKvcmpzqwfD2gfOAGNYJsa0thxocvDPjwk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
