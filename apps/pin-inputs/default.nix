{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-2nnFAP+KYdzBij14zwC0frwNSsQpCdxbsdBcSaKw3FM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
