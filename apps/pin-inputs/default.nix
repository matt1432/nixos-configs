{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7hS2/stupRjbQdHMv8B/wTc055+hlfaIeR1QUpQkGGY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
