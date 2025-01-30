{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-blhNKZ7sNPSHgnqPDZlslVfy04W+T6Noy2pncVpWmz4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
