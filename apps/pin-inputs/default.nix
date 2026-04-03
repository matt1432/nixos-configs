{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-UrOh27dVdKP1mutwbbMGTRZcMO4K6iDWz1uc32nQjkw=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
