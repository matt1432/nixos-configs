{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-huzj74mkWqeVbAtSLiaV/5RE+gRBJKfiYHTwqzzGyu8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
