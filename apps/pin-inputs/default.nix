{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-So35nohSJwiodIxK8v25EQN/wcAX8aNaaFmgQmva7G8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
