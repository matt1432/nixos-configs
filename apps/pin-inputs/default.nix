{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-/ooXh0LOuE9hVw0pmzbxKfHd6PXvGfbjuasUd8rMq+I=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
