{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-AK3Rk711vXvpcGS1JstTsPf22N+T8HAmb5gGR+VKN8Q=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
