{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-vZMelQ9ji7+oJi80LbaEBUDApKNQGcZ934jtcO3FFro=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
