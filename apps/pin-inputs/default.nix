{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-fk5yVpbPyJ5xOvYEKTG4EDFh4Ba7WwDjsyv2PmXz2eM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
