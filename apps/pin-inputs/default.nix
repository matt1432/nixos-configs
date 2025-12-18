{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-dCjIoKkHLTFpUHAkcJ+R6e0+GvyVbRYeGQgu40EGaUo=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
