{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-8otpj68XQ8Hv6bfoSRMCKzi2pq8j0o82vg65AKsWNNI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
