{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-yZ9iUipKnW79wLnY9/KIoVSUCFLUnxZvJ3Y5NlAv3vI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
