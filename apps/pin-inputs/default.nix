{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-YXLdzjBFJB8S2WQyu85rfWwAWZx+qWsalBVkGDENgAg=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
