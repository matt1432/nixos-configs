{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-JMu/G8FhWaGi4NEi78RX06URqMjS0/aHID2bbQZpzC0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
