{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ellUKba+zbRAs6TL2HOTMqFNXb6Q9ev3rhARvMVvHow=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
