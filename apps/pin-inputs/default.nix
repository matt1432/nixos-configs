{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-P/rsBTZ3Fk96a+gs+UAhJsUV8pzbalCaOXd8ejYp5q8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
