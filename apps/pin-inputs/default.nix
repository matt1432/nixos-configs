{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-NMry8rG7AY3Ep0HCPuBcPkGkORdYXjrBduaMdiu579s=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
