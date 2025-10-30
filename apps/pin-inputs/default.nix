{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-neIYWoBSXv6RQPjJwq07uA4w2P0aoQVBVJaQQGENG8c=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
