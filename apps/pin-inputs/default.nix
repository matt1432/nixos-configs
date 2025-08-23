{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-GZEdXf1qBUsMfWrMtxRWIgNWaiC7+fnVx8AKSsnrPMw=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
