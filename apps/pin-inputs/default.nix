{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-HYkVV0QpsjJK0u8wIztzm7UJbiA9U/oT6MbBHKNu3Cg=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
