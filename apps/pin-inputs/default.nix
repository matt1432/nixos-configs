{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-IVxAvHvMnp0zLAl02O/un9LR1LC8jZe0UZ9gzLnwPX8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
