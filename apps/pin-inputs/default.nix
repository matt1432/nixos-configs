{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-0cyJ/TiloLtGCE1GPLjr30/RoHTG2uXxLUgWl87srIA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
