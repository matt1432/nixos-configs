{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-fLa2uTD+KhEglHlD6BFugsIWgSKr1ODRBZeqM2ubYHs=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
