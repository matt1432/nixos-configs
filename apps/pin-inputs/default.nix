{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-DdgN5JpjRQvrcbM/4PsFgFfAAxFP1XKK2eJzniy/YBk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
