{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-LHh6KO3TM+e03eVYrqIo29xvDFXmQAXkQjrH2klXaUQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
