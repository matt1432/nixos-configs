{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-1kd6GQXpAXzisY57t026y8xVj07JCpfs6bC/UyXddqM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
