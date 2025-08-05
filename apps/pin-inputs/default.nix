{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-oOg0dOGD4HVv8RpiQbLWxbQTnMBkzMSzD+JWxrSvxyQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
