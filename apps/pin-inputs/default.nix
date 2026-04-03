{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-i5H0yNN2Dpj7ynQ4dc/8GXZA8xsTTSVZPkZTwCKHHDQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
