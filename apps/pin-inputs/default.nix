{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-HM+5Gn9GUbIMXZF6JM9g8QHGugNnEjvidOloVwS0EvM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
