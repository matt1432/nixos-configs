{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-odvraAVWwWAor+IKXrt9rWno9+RH45MgqupGluB5zDI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
