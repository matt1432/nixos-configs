{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-fcCTvmbt3hr2sYobsrVn/+hrfLswa5M7AJXx+AXicrU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
