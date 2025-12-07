{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-3RIDldS2Z9OsoDHNDWj37UwmyB54SPVmTGHCszu99QM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
