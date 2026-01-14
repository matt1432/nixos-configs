{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-j+HxGl4r3DZ6V533OHcf4MEhMwGqdmcHUhUuozwQWoI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
