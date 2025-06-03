{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Z9xyq3T66PXg982SAMBtAZdfBo6e3gZ30N8AcgUZ64k=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
