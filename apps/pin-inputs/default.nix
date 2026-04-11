{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-cHrKRoYRnThauPxRUFbpGF/GaFSaY66K2ZzCHqY5Z/8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
