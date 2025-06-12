{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-xXHvm4gclJVCfRY5l0FFwNiQ8AmGWO8ypYX2xGsx3YE=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
