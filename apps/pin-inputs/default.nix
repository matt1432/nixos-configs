{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-kAghAgp9Y5Ieep2GgpF9eeM8RAt8kwsx4BUjlcGUuss=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
