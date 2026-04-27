{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-gn2/83pGQvKl4bVrNGBrIUxYXXR3/OZt2MxO/2EtKK8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
