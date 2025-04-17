{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-oF5IFeBmtQ8ThhJtTcR1JuyWXU6zgCcqmKudi054E4w=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
