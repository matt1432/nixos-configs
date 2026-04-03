{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-xwCxz+Bd2sKesBjdUl/i/A7ZKw3jgUv7SA3RTowEOFQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
