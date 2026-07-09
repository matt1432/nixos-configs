{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-4zelELRWB7qKQLkkLIDfoF5APnFCEM5BrNKf4sGeimk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
