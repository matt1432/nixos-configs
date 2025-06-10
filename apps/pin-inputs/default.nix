{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-bfVq9oWDR9KvVJLFJ0hUDwjb9ARZYaM1Rnxwo3LgvFM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
