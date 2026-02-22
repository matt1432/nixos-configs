{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Q+V5zQqhHEs3nSv9ddw9LAuyJQ9ev6dvCYZVcVIePJM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
