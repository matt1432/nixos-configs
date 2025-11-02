{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-zdad5Jk67/htwNQ7xArrfwa4TQQg2pGGT8BlZYPdkfo=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
