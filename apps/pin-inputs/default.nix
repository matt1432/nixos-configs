{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ajm7vZTvHVW2JAEzD8W6WMw4AkaBfcPKE4f8RP45ds4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
