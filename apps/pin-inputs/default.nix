{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XU2cFtq2oceaDvLG8fiItTP5kBAqjQEj3qIwlqt0YQM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
