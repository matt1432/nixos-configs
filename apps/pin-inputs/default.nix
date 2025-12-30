{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-dXq8uSqNqNmKxjWiHW8MtNb9HLnLqVDScbHTutKTjFk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
