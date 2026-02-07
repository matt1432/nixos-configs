{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XXAWAAZrG6iNoR9M6XXPCI2Ah4Hc35pvVUIQW9qd5Eg=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
