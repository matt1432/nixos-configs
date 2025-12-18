{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-r0s5x49lTwT29l9nZ0IMP1MFZ64w8i8L8921YIckroE=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
