{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-fosJ2gQtKwscv/kvGu8Lw1IIVZ1EHxLE0rIo4jY3yZY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
