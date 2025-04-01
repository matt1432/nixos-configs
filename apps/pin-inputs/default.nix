{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-cFB7hWrm6cl0T05ToBcyYtS/3RBNxteIltN2JuNulx8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
