{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-DFnrTXGSdf4UtghtjF9CnaJpZPfsMnENP5nOcsSdjt4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
