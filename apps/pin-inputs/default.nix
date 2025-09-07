{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-SLfjMQrkK54KaHjsiHcxjaA8K88OtiEK9HxgoYbR8AI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
