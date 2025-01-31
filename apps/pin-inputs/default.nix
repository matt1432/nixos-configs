{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-NDGZ+NAuiSHtqAxP4t/nElyjyEB4NUwl+pzkup6B0hA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
