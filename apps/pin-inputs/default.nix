{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-rhUlFjE4W3GXZ4zmMk4dmkZpauBwXZI8W8iu2F6NmUM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
