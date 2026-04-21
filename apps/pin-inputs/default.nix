{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-UuyWpyOAImt4sxsxFaEMYiZ1LVkAaOSV1dF05EUitTY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
