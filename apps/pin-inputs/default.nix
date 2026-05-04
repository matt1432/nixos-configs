{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-mw3H9r9qmmNbagFOsrahocnLiYdQ4mI1+NXRKaysOLo=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
