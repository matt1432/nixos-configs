{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ruV5Lb3VhDeE+ssErCygNHA7oqhEReTiTwc9tEbp3/o=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
