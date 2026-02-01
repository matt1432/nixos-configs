{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-6ugCF0jwBGz11To9GP/GvU6B1V5DTM2jAX7xZ9QYQ7M=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
