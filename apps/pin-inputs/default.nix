{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-s4eh0nL52/bS/yIo2BQgdTN6l3SiD2NTY2KntxjpIl4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
