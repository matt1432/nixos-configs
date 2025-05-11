{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-jLiKRPXWrGl2p8pikGpnW6Yl1qcnvGqcDa77vih6Vvs=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
