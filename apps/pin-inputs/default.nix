{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-hEBQhFnOVHiZx0AF1J+SQXOZ+3Tq4IUxY6aBWO1P/lA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
