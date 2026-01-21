{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-BvVnt77Fvtwf/Dw5aFlbs42DQssuFhG2p0ZLb/rcRUk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
