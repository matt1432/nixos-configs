{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-1641Ek7hDwlMqWt8JpTgP4jmNwKP74W5zZVZ5cmRj3A=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
