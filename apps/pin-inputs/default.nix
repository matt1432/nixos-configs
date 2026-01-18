{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-AyCPov0pIr9KewFvWU8vgWDEa6bfQ62ie8ri2LcpNGU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
