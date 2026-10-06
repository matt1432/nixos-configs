{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-CR69Qw4CtfkERvTlDY+Dc7wfrn5oQFJWn3PiKT7kDzk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
