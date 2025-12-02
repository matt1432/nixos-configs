{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-TotADzxhB/1mYcOEvHut5x+zBZAmsp7G2LBm92YJk6I=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
