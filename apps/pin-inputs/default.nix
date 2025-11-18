{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-aO/ryB34CfYio+05EkXWSE9wfT7wNmT5FBh1BL4fd48=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
