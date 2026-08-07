{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-LVcEDpm08rmlL++1zV6v4kNVWUmR4A2L87s78wktv4o=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
