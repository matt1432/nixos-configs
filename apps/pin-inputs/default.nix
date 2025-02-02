{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-DPgNc+6mn7STYYdr6Wqhl08QeVtbzU9sqd67sAv2EgM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
