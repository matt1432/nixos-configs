{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-klLMRTUWsU0Kn8JnTkqW6MXc30eQFu15yBPEBjcjKV0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
